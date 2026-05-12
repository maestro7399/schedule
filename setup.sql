-- ═══════════════════════════════════════════════════════════
--  会議ボード — Supabase テーブルセットアップ
--  Supabase の SQL Editor にこのファイルを貼り付けて実行してください
-- ═══════════════════════════════════════════════════════════

-- 1. meetings テーブル作成
create table if not exists public.meetings (
  id            text        primary key,
  title         text        not null,
  date          date,
  time          time,
  location      text,
  participants  text[]      default '{}',
  minutes_link  text,
  agenda        text,
  notes         text,
  todos         jsonb       default '[]',
  status        text        default 'upcoming',
  rsvp          jsonb       default '{}',
  created_at    timestamptz default now(),
  updated_at    timestamptz default now()
);

-- 2. updated_at を自動更新するトリガー
create or replace function public.handle_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_updated_at on public.meetings;
create trigger set_updated_at
  before update on public.meetings
  for each row execute function public.handle_updated_at();

-- 3. Row Level Security（RLS）の設定
--    ※ 全員が読み書き可能な公開設定です
--      認証が必要な場合は別途ポリシーを変更してください
alter table public.meetings enable row level security;

-- 全員が SELECT（読み取り）可能
create policy "Anyone can read meetings"
  on public.meetings for select
  using (true);

-- 全員が INSERT（追加）可能
create policy "Anyone can insert meetings"
  on public.meetings for insert
  with check (true);

-- 全員が UPDATE（更新）可能
create policy "Anyone can update meetings"
  on public.meetings for update
  using (true);

-- 全員が DELETE（削除）可能
create policy "Anyone can delete meetings"
  on public.meetings for delete
  using (true);

-- 4. Realtime を有効化
alter publication supabase_realtime add table public.meetings;

-- 完了メッセージ
select 'テーブルのセットアップが完了しました ✅' as message;
