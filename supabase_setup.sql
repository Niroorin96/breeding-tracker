-- =====================================================================
-- Breeding Tracker · Poke Idle World  —  configuração do banco (Supabase)
-- Cole TUDO isto no "SQL Editor" do Supabase e clique em RUN (uma vez só).
-- Pode rodar de novo sem problema: não apaga dados existentes.
-- =====================================================================

-- 1) Extensão para guardar o PIN de forma criptografada
create extension if not exists pgcrypto with schema extensions;

-- 2) Tabela única: uma linha por conta (nick), com todos os dados dentro de "data"
create table if not exists public.piw_accounts (
  nick         text primary key,                 -- nick (minúsculo)
  pin_hash     text not null,                    -- PIN criptografado (bcrypt)
  token        uuid not null default gen_random_uuid(),  -- "chave de sessão" usada pelo site
  data         jsonb not null default '{"projects":[]}'::jsonb,
  fails        int  not null default 0,          -- tentativas de PIN erradas
  locked_until timestamptz,                      -- bloqueio temporário
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

-- 3) Segurança: ninguém lê/escreve a tabela diretamente (sem policies).
--    O site só conversa com o banco pelas 5 funções abaixo.
alter table public.piw_accounts enable row level security;
revoke all on public.piw_accounts from anon, authenticated;

-- 4) Entrar (confere nick + PIN; bloqueia 15 min após 8 erros seguidos)
create or replace function public.piw_login(p_nick text, p_pin text)
returns jsonb
language plpgsql security definer set search_path = public, extensions
as $$
declare a public.piw_accounts%rowtype; n int;
begin
  p_nick := lower(trim(coalesce(p_nick,'')));
  select * into a from public.piw_accounts where nick = p_nick;
  if not found then return jsonb_build_object('status','new'); end if;
  if a.locked_until is not null and a.locked_until > now() then
    return jsonb_build_object('status','locked');
  end if;
  if a.pin_hash = crypt(coalesce(p_pin,''), a.pin_hash) then
    update public.piw_accounts set fails = 0, locked_until = null where nick = p_nick;
    return jsonb_build_object('status','ok','token',a.token,'data',a.data,'updated_at',a.updated_at);
  end if;
  n := a.fails + 1;
  update public.piw_accounts
     set fails = case when n >= 8 then 0 else n end,
         locked_until = case when n >= 8 then now() + interval '15 minutes' else null end
   where nick = p_nick;
  return jsonb_build_object('status','bad_pin','left', greatest(8 - n, 0));
end $$;

-- 5) Criar conta (nick novo)
create or replace function public.piw_register(p_nick text, p_pin text, p_data jsonb)
returns jsonb
language plpgsql security definer set search_path = public, extensions
as $$
declare v_token uuid; v_at timestamptz;
begin
  p_nick := lower(trim(coalesce(p_nick,'')));
  if char_length(p_nick) not between 2 and 32 then return jsonb_build_object('status','invalid_nick'); end if;
  if p_pin is null or p_pin !~ '^[0-9]{4}$' then return jsonb_build_object('status','invalid_pin'); end if;
  if p_data is null or coalesce(jsonb_typeof(p_data->'projects'),'') <> 'array' or pg_column_size(p_data) > 2000000 then
    return jsonb_build_object('status','invalid_data');
  end if;
  insert into public.piw_accounts(nick, pin_hash, data)
  values (p_nick, crypt(p_pin, gen_salt('bf')), p_data)
  on conflict (nick) do nothing
  returning token, updated_at into v_token, v_at;
  if v_token is null then return jsonb_build_object('status','exists'); end if;
  return jsonb_build_object('status','ok','token',v_token,'updated_at',v_at);
end $$;

-- 6) Salvar os dados (exige nick + token da sessão)
create or replace function public.piw_save(p_nick text, p_token uuid, p_data jsonb)
returns jsonb
language plpgsql security definer set search_path = public, extensions
as $$
declare v_at timestamptz;
begin
  if p_data is null or coalesce(jsonb_typeof(p_data->'projects'),'') <> 'array' or pg_column_size(p_data) > 2000000 then
    return jsonb_build_object('status','invalid_data');
  end if;
  update public.piw_accounts set data = p_data, updated_at = now()
   where nick = lower(trim(coalesce(p_nick,''))) and token = p_token
  returning updated_at into v_at;
  if v_at is null then return jsonb_build_object('status','unauthorized'); end if;
  return jsonb_build_object('status','ok','updated_at',v_at);
end $$;

-- 7) Carregar os dados (login automático / atualizar)
create or replace function public.piw_load(p_nick text, p_token uuid)
returns jsonb
language plpgsql security definer set search_path = public, extensions
as $$
declare a public.piw_accounts%rowtype;
begin
  select * into a from public.piw_accounts
   where nick = lower(trim(coalesce(p_nick,''))) and token = p_token;
  if not found then return jsonb_build_object('status','unauthorized'); end if;
  return jsonb_build_object('status','ok','data',a.data,'updated_at',a.updated_at);
end $$;

-- 8) (opcional) "ping" para evitar que o projeto gratuito pause por inatividade
create or replace function public.piw_ping()
returns text language sql security definer set search_path = public
as $$ select 'ok'::text $$;

-- 9) Permissões: o site (papel "anon") só pode chamar estas funções
grant usage on schema public to anon;
grant execute on function public.piw_login(text,text)        to anon;
grant execute on function public.piw_register(text,text,jsonb) to anon;
grant execute on function public.piw_save(text,uuid,jsonb)   to anon;
grant execute on function public.piw_load(text,uuid)         to anon;
grant execute on function public.piw_ping()                  to anon;

notify pgrst, 'reload schema';
