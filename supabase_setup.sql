-- Hanh Tinh Xanh: Supabase REST setup (publishable key, no user accounts)
-- Run the whole file in Supabase Dashboard > SQL Editor.

create table if not exists public.online_nodes (
  path text primary key,
  value jsonb not null default 'null'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.online_nodes enable row level security;
grant select, insert, update, delete on public.online_nodes to anon;

drop policy if exists "public read online nodes" on public.online_nodes;
drop policy if exists "public insert online nodes" on public.online_nodes;
drop policy if exists "public update online nodes" on public.online_nodes;
drop policy if exists "public delete online nodes" on public.online_nodes;

create policy "public read online nodes" on public.online_nodes
  for select to anon using (path like 'rooms/%' or path like 'lb/%');
create policy "public insert online nodes" on public.online_nodes
  for insert to anon with check (path like 'rooms/%' or path like 'lb/%');
create policy "public update online nodes" on public.online_nodes
  for update to anon using (path like 'rooms/%' or path like 'lb/%')
  with check (path like 'rooms/%' or path like 'lb/%');
create policy "public delete online nodes" on public.online_nodes
  for delete to anon using (path like 'rooms/%' or path like 'lb/%');

create index if not exists online_nodes_path_prefix_idx
  on public.online_nodes (path text_pattern_ops);

create or replace function public.server_timestamp_ms()
returns bigint
language sql
volatile
as $$
  select (extract(epoch from clock_timestamp()) * 1000)::bigint;
$$;

grant execute on function public.server_timestamp_ms() to anon;
notify pgrst, 'reload schema';
