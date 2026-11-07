
-- =====================================================
-- 90-DAY SUCCESS TRACKER
-- SUPABASE DATABASE + PRIVATE STORAGE
-- =====================================================

-- 1. PERSONAL TRACKER DATA
CREATE TABLE IF NOT EXISTS public.tracker_data (
    user_id UUID PRIMARY KEY
        REFERENCES auth.users(id) ON DELETE CASCADE,
    data JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.tracker_data ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can view own tracker"
ON public.tracker_data;

CREATE POLICY "Users can view own tracker"
ON public.tracker_data
FOR SELECT TO authenticated
USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert own tracker"
ON public.tracker_data;

CREATE POLICY "Users can insert own tracker"
ON public.tracker_data
FOR INSERT TO authenticated
WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update own tracker"
ON public.tracker_data;

CREATE POLICY "Users can update own tracker"
ON public.tracker_data
FOR UPDATE TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);


-- 2. WEEKLY PROOF FILE INFORMATION
CREATE TABLE IF NOT EXISTS public.proof_uploads (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL
        REFERENCES auth.users(id) ON DELETE CASCADE,
    week_number INTEGER NOT NULL
        CHECK (week_number BETWEEN 1 AND 13),
    title TEXT NOT NULL,
    description TEXT DEFAULT '',
    file_name TEXT NOT NULL,
    file_path TEXT NOT NULL,
    file_type TEXT,
    file_size BIGINT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.proof_uploads ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can view own uploads"
ON public.proof_uploads;

CREATE POLICY "Users can view own uploads"
ON public.proof_uploads
FOR SELECT TO authenticated
USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can add own uploads"
ON public.proof_uploads;

CREATE POLICY "Users can add own uploads"
ON public.proof_uploads
FOR INSERT TO authenticated
WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete own uploads"
ON public.proof_uploads;

CREATE POLICY "Users can delete own uploads"
ON public.proof_uploads
FOR DELETE TO authenticated
USING (auth.uid() = user_id);


-- 3. PRIVATE STORAGE BUCKET
INSERT INTO storage.buckets (
    id,
    name,
    public,
    file_size_limit
)
VALUES (
    'weekly-proof',
    'weekly-proof',
    false,
    26214400
)
ON CONFLICT (id)
DO UPDATE SET
    public = false,
    file_size_limit = 26214400;


-- 4. USERS CAN VIEW THEIR OWN FILES
DROP POLICY IF EXISTS "Users can view own proof files"
ON storage.objects;

CREATE POLICY "Users can view own proof files"
ON storage.objects
FOR SELECT TO authenticated
USING (
    bucket_id = 'weekly-proof'
    AND (storage.foldername(name))[1] = auth.uid()::text
);


-- 5. USERS CAN UPLOAD INTO THEIR OWN FOLDER
DROP POLICY IF EXISTS "Users can upload own proof files"
ON storage.objects;

CREATE POLICY "Users can upload own proof files"
ON storage.objects
FOR INSERT TO authenticated
WITH CHECK (
    bucket_id = 'weekly-proof'
    AND (storage.foldername(name))[1] = auth.uid()::text
);


-- 6. USERS CAN DELETE THEIR OWN FILES
DROP POLICY IF EXISTS "Users can delete own proof files"
ON storage.objects;

CREATE POLICY "Users can delete own proof files"
ON storage.objects
FOR DELETE TO authenticated
USING (
    bucket_id = 'weekly-proof'
    AND (storage.foldername(name))[1] = auth.uid()::text
);


-- 7. FINISH
SELECT '90-Day Success Tracker setup completed!' AS status;
