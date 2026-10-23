-- Hanh Tinh Xanh: Supabase REST setup (no SDK, no user accounts)
create table if not exists public.online_nodes (
  path text primary key,
  value jsonb not null default 'null'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.online_nodes enable row level security;
drop policy if exists "public read online nodes" on public.online_nodes;
drop policy if exists "public insert online nodes" on public.online_nodes;
drop policy if exists "public update online nodes" on public.online_nodes;
drop policy if exists "public delete online nodes" on public.online_nodes;
create policy "public read online nodes" on public.online_nodes for select to anon using (true);
create policy "public insert online nodes" on public.online_nodes for insert to anon with check (true);
create policy "public update online nodes" on public.online_nodes for update to anon using (true) with check (true);
create policy "public delete online nodes" on public.online_nodes for delete to anon using (true);

create index if not exists online_nodes_path_prefix_idx on public.online_nodes (path text_pattern_ops);
