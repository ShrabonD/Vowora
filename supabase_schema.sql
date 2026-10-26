-- VOWORA - Clean Production Database Schema (0 Pre-populated User Data)
-- Copy and run this script in your Supabase Dashboard SQL Editor

-- 1. PROFILES TABLE
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    location TEXT,
    avatar_url TEXT,
    role TEXT DEFAULT 'client',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Profiles are viewable by authenticated users" ON public.profiles;
DROP POLICY IF EXISTS "Users can insert their own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON public.profiles;

CREATE POLICY "Profiles are viewable by authenticated users"
    ON public.profiles FOR SELECT USING (true);

CREATE POLICY "Users can insert their own profile"
    ON public.profiles FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can update their own profile"
    ON public.profiles FOR UPDATE USING (true);

-- 2. WEDDINGS TABLE (Main Event Entity)
CREATE TABLE IF NOT EXISTS public.wedding_profiles (
    id TEXT PRIMARY KEY, -- e.g. WED-8F42K9 or WED-2026-0001
    user_id UUID,
    bride_name TEXT NOT NULL,
    groom_name TEXT NOT NULL,
    bride_phone TEXT,
    groom_phone TEXT,
    wedding_date TIMESTAMP WITH TIME ZONE NOT NULL,
    wedding_time TEXT DEFAULT '06:00 PM',
    wedding_type TEXT DEFAULT 'royal',
    expected_guest_count INT DEFAULT 300,
    description TEXT,
    bride_photo_url TEXT,
    groom_photo_url TEXT,
    cover_photo_url TEXT,
    venue_name TEXT,
    venue_location TEXT,
    total_planned_budget NUMERIC(12,2) DEFAULT 400000.00,
    is_confirmed BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.wedding_profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Weddings are viewable by anyone with wedding_id or invitation code" ON public.wedding_profiles;

CREATE POLICY "Weddings are viewable by anyone with wedding_id or invitation code"
    ON public.wedding_profiles FOR ALL USING (true);

-- 3. GUESTS & RSVP TABLE
CREATE TABLE IF NOT EXISTS public.guests (
    id TEXT PRIMARY KEY,
    wedding_id TEXT NOT NULL REFERENCES public.wedding_profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    phone TEXT,
    email TEXT,
    group_family TEXT DEFAULT 'Friends',
    number_of_guests INT DEFAULT 1,
    is_invited BOOLEAN DEFAULT true,
    rsvp_status TEXT DEFAULT 'pending', -- pending, confirmed, declined
    meal_preference TEXT DEFAULT 'Regular',
    special_request TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.guests ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Anyone can view and submit guest RSVP" ON public.guests;

CREATE POLICY "Anyone can view and submit guest RSVP"
    ON public.guests FOR ALL USING (true);

-- 4. SERVICE PROVIDERS MARKETPLACE TABLE (Marketplace Directory)
CREATE TABLE IF NOT EXISTS public.service_providers (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    type TEXT NOT NULL, -- photographer, decorator, caterer, etc.
    location TEXT,
    rating NUMERIC(3,2) DEFAULT 4.90,
    reviews_count INT DEFAULT 50,
    starting_price NUMERIC(12,2) DEFAULT 25000.00,
    portfolio_count INT DEFAULT 20,
    is_available BOOLEAN DEFAULT true,
    profile_image_url TEXT,
    bio TEXT,
    portfolio_images TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.service_providers ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Service providers are viewable by everyone" ON public.service_providers;

CREATE POLICY "Service providers are viewable by everyone"
    ON public.service_providers FOR ALL USING (true);

-- 5. SERVICE BOOKINGS TABLE
CREATE TABLE IF NOT EXISTS public.service_bookings (
    id TEXT PRIMARY KEY,
    provider_id TEXT REFERENCES public.service_providers(id) ON DELETE CASCADE,
    provider_name TEXT NOT NULL,
    provider_type TEXT NOT NULL,
    client_id TEXT NOT NULL,
    client_name TEXT NOT NULL,
    wedding_id TEXT NOT NULL REFERENCES public.wedding_profiles(id) ON DELETE CASCADE,
    wedding_name TEXT NOT NULL,
    wedding_date TIMESTAMP WITH TIME ZONE NOT NULL,
    venue_name TEXT,
    package_name TEXT NOT NULL,
    total_price NUMERIC(12,2) NOT NULL,
    advance_paid NUMERIC(12,2) DEFAULT 0.00,
    status TEXT DEFAULT 'pending', -- pending, accepted, rejected, completed
    payment_status TEXT DEFAULT 'Pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.service_bookings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Bookings are viewable and manageable by involved parties" ON public.service_bookings;

CREATE POLICY "Bookings are viewable and manageable by involved parties"
    ON public.service_bookings FOR ALL USING (true);

-- 6. WEDDING PHOTOS GALLERY TABLE
CREATE TABLE IF NOT EXISTS public.wedding_photos (
    id TEXT PRIMARY KEY,
    wedding_id TEXT NOT NULL REFERENCES public.wedding_profiles(id) ON DELETE CASCADE,
    album_name TEXT DEFAULT 'Ceremony',
    image_url TEXT NOT NULL,
    uploader_id TEXT,
    uploader_name TEXT NOT NULL,
    uploader_role TEXT DEFAULT 'client', -- client, serviceProvider, guest
    visibility TEXT DEFAULT 'publicToGuests', -- publicToGuests, clientOnly, private
    approval_status TEXT DEFAULT 'approved', -- pendingApproval, approved, rejected
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.wedding_photos ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Photos viewable by everyone" ON public.wedding_photos;

CREATE POLICY "Photos viewable by everyone"
    ON public.wedding_photos FOR ALL USING (true);

-- 7. WEDDING SCHEDULE TIMELINE TABLE
CREATE TABLE IF NOT EXISTS public.wedding_schedule (
    id TEXT PRIMARY KEY,
    wedding_id TEXT NOT NULL REFERENCES public.wedding_profiles(id) ON DELETE CASCADE,
    time_string TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    location TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.wedding_schedule ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Schedule viewable by everyone" ON public.wedding_schedule;

CREATE POLICY "Schedule viewable by everyone"
    ON public.wedding_schedule FOR ALL USING (true);

-- 8. CHECKLIST TASKS TABLE
CREATE TABLE IF NOT EXISTS public.checklist_tasks (
    id TEXT PRIMARY KEY,
    wedding_id TEXT REFERENCES public.wedding_profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    due_date TIMESTAMP WITH TIME ZONE,
    priority TEXT DEFAULT 'medium',
    status TEXT DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.checklist_tasks ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Tasks viewable by wedding owner" ON public.checklist_tasks;

CREATE POLICY "Tasks viewable by wedding owner"
    ON public.checklist_tasks FOR ALL USING (true);

-- 9. PAYMENT RECORDS TABLE (bKash, Nagad, Rocket, TrxID & Installments)
CREATE TABLE IF NOT EXISTS public.payment_records (
    id TEXT PRIMARY KEY,
    wedding_id TEXT NOT NULL REFERENCES public.wedding_profiles(id) ON DELETE CASCADE,
    service_name TEXT NOT NULL,
    amount NUMERIC(12,2) NOT NULL,
    payment_method TEXT DEFAULT 'bKash',
    transaction_id TEXT,
    sender_phone TEXT,
    payment_type TEXT DEFAULT '50% Advance (Half Payment)',
    invoice_no TEXT,
    status TEXT DEFAULT 'Verified ✓',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.payment_records ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Payments viewable by wedding owner" ON public.payment_records;

CREATE POLICY "Payments viewable by wedding owner"
    ON public.payment_records FOR ALL USING (true);

-- 10. CLEAN SLATE: TRUNCATE ALL MOCK DEMO USER DATA
TRUNCATE TABLE public.guests CASCADE;
TRUNCATE TABLE public.wedding_photos CASCADE;
TRUNCATE TABLE public.wedding_schedule CASCADE;
TRUNCATE TABLE public.checklist_tasks CASCADE;
TRUNCATE TABLE public.payment_records CASCADE;
TRUNCATE TABLE public.service_bookings CASCADE;
TRUNCATE TABLE public.wedding_profiles CASCADE;

-- Default Marketplace Vendors Catalog (So clients can browse vendors)
INSERT INTO public.service_providers (id, name, type, location, rating, reviews_count, starting_price, portfolio_count, is_available, profile_image_url, bio, portfolio_images)
VALUES
('sp1', 'Dream Lens Studio', 'photographer', 'Sylhet & Dhaka', 4.90, 142, 25000.00, 48, true, 'https://images.unsplash.com/photo-1537633552985-df8429e8048b', 'Award winning wedding photography & 4K cinematic reels studio.', ARRAY['https://images.unsplash.com/photo-1537633552985-df8429e8048b', 'https://images.unsplash.com/photo-1606800052052-a08af7148866']),
('sp2', 'Blossom Floral Couture', 'decorator', 'Banani, Dhaka', 4.80, 96, 45000.00, 32, true, 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3', 'Luxury floral arches, crystal stage drapes & ambient lighting.', ARRAY['https://images.unsplash.com/photo-1519167758481-83f550bb49b3']),
('sp3', 'Royal Shahi Feast Catering', 'caterer', 'Dhanmondi, Dhaka', 4.90, 210, 650.00, 18, true, 'https://images.unsplash.com/photo-1555244162-803834f70033', 'Authentic Mutton Kacchi Biryani & Moghul Shahi Buffet spreads.', ARRAY['https://images.unsplash.com/photo-1555244162-803834f70033'])
ON CONFLICT (id) DO NOTHING;

-- 11. ENABLE REALTIME PUBLICATION
DROP PUBLICATION IF EXISTS supabase_realtime;
CREATE PUBLICATION supabase_realtime FOR ALL TABLES;

-- AUTOMATIC PROFILE CREATION TRIGGER
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, full_name, email, phone, location)
    VALUES (
        new.id,
        COALESCE(new.raw_user_meta_data->>'full_name', 'Planner'),
        new.email,
        COALESCE(new.raw_user_meta_data->>'phone', ''),
        COALESCE(new.raw_user_meta_data->>'location', '')
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
