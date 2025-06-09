-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- PROFILES TABLE
CREATE TABLE public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    first_name TEXT, -- Removed NOT NULL to allow phone auth without name
    last_name TEXT,  -- Removed NOT NULL to allow phone auth without name
    phone_number TEXT,
    email TEXT,
    birth_date DATE,
    location_id UUID,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- LOCATIONS TABLE
CREATE TABLE public.locations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    state TEXT,
    country TEXT DEFAULT 'India',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add foreign key constraint after both tables are created
ALTER TABLE public.profiles 
ADD CONSTRAINT fk_profiles_location 
FOREIGN KEY (location_id) REFERENCES public.locations(id);

-- EQUIPMENT CATEGORIES TABLE
CREATE TABLE public.equipment_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    icon_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- EQUIPMENT TYPES TABLE
CREATE TABLE public.equipment_types (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id UUID NOT NULL REFERENCES public.equipment_categories(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- NGOs TABLE
CREATE TABLE public.ngos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    address TEXT,
    contact_number TEXT,
    email TEXT,
    website TEXT,
    description TEXT,
    location_id UUID NOT NULL REFERENCES public.locations(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- NGO EQUIPMENT INVENTORY (joining table with details)
CREATE TABLE public.ngo_equipment (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ngo_id UUID NOT NULL REFERENCES public.ngos(id) ON DELETE CASCADE,
    equipment_type_id UUID NOT NULL REFERENCES public.equipment_types(id) ON DELETE CASCADE,
    condition TEXT, -- e.g., 'New', 'Good', 'Fair'
    quantity INT DEFAULT 1,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- EQUIPMENT IMAGES TABLE
CREATE TABLE public.equipment_images (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ngo_equipment_id UUID NOT NULL REFERENCES public.ngo_equipment(id) ON DELETE CASCADE,
    image_url TEXT NOT NULL,
    is_primary BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create an automatic trigger to create profile entry when a user signs up
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (
        id, 
        first_name, 
        last_name, 
        email, 
        phone_number,
        birth_date
    )
    VALUES (
        NEW.id, 
        NULLIF(COALESCE(NEW.raw_user_meta_data->>'first_name', ''), ''),
        NULLIF(COALESCE(NEW.raw_user_meta_data->>'last_name', ''), ''),
        NULLIF(NEW.email, ''),
        NULLIF(NEW.phone, ''),
        (CASE 
            WHEN NEW.raw_user_meta_data->>'birth_date' IS NOT NULL AND NEW.raw_user_meta_data->>'birth_date' != '' 
            THEN (NEW.raw_user_meta_data->>'birth_date')::date 
            ELSE NULL 
        END)
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for new user signup
CREATE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Enable Row Level Security
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.equipment_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.equipment_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ngos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ngo_equipment ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.equipment_images ENABLE ROW LEVEL SECURITY;

-- RLS Policies

-- Profiles: Users can only read/update their own profile
CREATE POLICY "Users can view own profile" ON public.profiles 
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.profiles
    FOR UPDATE USING (auth.uid() = id);

-- Locations: Public read access
CREATE POLICY "Public can view locations" ON public.locations
    FOR SELECT USING (true);

-- Equipment Categories: Public read access
CREATE POLICY "Public can view equipment categories" ON public.equipment_categories
    FOR SELECT USING (true);

-- Equipment Types: Public read access 
CREATE POLICY "Public can view equipment types" ON public.equipment_types
    FOR SELECT USING (true);

-- NGOs: Public read access
CREATE POLICY "Public can view NGOs" ON public.ngos
    FOR SELECT USING (true);

-- NGO Equipment: Public read access
CREATE POLICY "Public can view NGO equipment" ON public.ngo_equipment
    FOR SELECT USING (true);

-- Equipment Images: Public read access
CREATE POLICY "Public can view equipment images" ON public.equipment_images
    FOR SELECT USING (true);

-- Insert sample data

-- Insert locations
INSERT INTO public.locations (name, state) VALUES
('Bardoli', 'Gujarat'),
('Bilimora', 'Gujarat');

-- Insert equipment categories
INSERT INTO public.equipment_categories (name, description) VALUES
('Mobility Aids', 'Equipment to help with mobility issues'),
('Hospital Furniture', 'Beds and other hospital furniture'),
('Patient Transfer', 'Equipment for transferring patients'),
('Neck Care', 'Equipment for neck support and care'),
('Respiratory Care', 'Equipment for respiratory assistance');

-- Insert equipment types
INSERT INTO public.equipment_types (category_id, name, description)
VALUES 
((SELECT id FROM public.equipment_categories WHERE name = 'Hospital Furniture'), 'Hospital Bed', 'Standard hospital bed for patient care'),
((SELECT id FROM public.equipment_categories WHERE name = 'Mobility Aids'), 'Walking Stick', 'Standard walking stick for mobility assistance'),
((SELECT id FROM public.equipment_categories WHERE name = 'Mobility Aids'), 'Crutches', 'Underarm or forearm crutches for walking assistance'),
((SELECT id FROM public.equipment_categories WHERE name = 'Mobility Aids'), 'Walker', 'Frame to support walking'),
((SELECT id FROM public.equipment_categories WHERE name = 'Patient Transfer'), 'Wheelchair', 'Chair with wheels for mobility'),
((SELECT id FROM public.equipment_categories WHERE name = 'Patient Transfer'), 'Stretcher', 'Device to carry patients'),
((SELECT id FROM public.equipment_categories WHERE name = 'Neck Care'), 'Cervical Collar', 'Support for cervical spine'),
((SELECT id FROM public.equipment_categories WHERE name = 'Neck Care'), 'Philadelphia Collar', 'Rigid cervical orthosis'),
((SELECT id FROM public.equipment_categories WHERE name = 'Respiratory Care'), 'Pulse Oximeter', 'Device to measure oxygen levels'),
((SELECT id FROM public.equipment_categories WHERE name = 'Respiratory Care'), 'Nebulizer', 'Device for administering medication in mist form');

-- Insert NGOs
INSERT INTO public.ngos (name, contact_number, location_id)
VALUES
('I M HUMAN CHARITABLE TRUST', '8460517015', (SELECT id FROM public.locations WHERE name = 'Bardoli')),
('Beyond Humanity Foundation (NGO)', '7016960550', (SELECT id FROM public.locations WHERE name = 'Bardoli')),
('Diwaliben Ukabhai Patel Sarvajanik Trust', NULL, (SELECT id FROM public.locations WHERE name = 'Bardoli')),
('Universal Welfare Trust', NULL, (SELECT id FROM public.locations WHERE name = 'Bardoli')),
('Vatsalya Trust', NULL, (SELECT id FROM public.locations WHERE name = 'Bardoli')),
('WILDLIFE WELFARE FOUNDATION NAVSARI', NULL, (SELECT id FROM public.locations WHERE name = 'Bilimora')),
('GAU SEVA SANSTHAN', NULL, (SELECT id FROM public.locations WHERE name = 'Bilimora')),
('LIONS CLUB', NULL, (SELECT id FROM public.locations WHERE name = 'Bilimora'));