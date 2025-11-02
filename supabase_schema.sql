-- Supabase Database Schema for SaaS Platform
-- Run this SQL in your Supabase SQL Editor to create the required tables

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table (extends Supabase auth.users)
CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    metadata JSONB DEFAULT '{}'::jsonb
);

-- Enable Row Level Security
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Users can read their own data
CREATE POLICY "Users can read own data" ON public.users
    FOR SELECT USING (auth.uid() = id);

-- Users can update their own data
CREATE POLICY "Users can update own data" ON public.users
    FOR UPDATE USING (auth.uid() = id);

-- Customers table
CREATE TABLE IF NOT EXISTS public.customers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    discord_id TEXT,
    discord_username TEXT,
    twitter_id TEXT,
    twitter_username TEXT,
    wallet_address TEXT,
    product_ids TEXT[] DEFAULT ARRAY[]::TEXT[],
    roles TEXT[] DEFAULT ARRAY[]::TEXT[],
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    metadata JSONB DEFAULT '{}'::jsonb,
    UNIQUE(user_id)
);

ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Customers can read own data" ON public.customers
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Customers can update own data" ON public.customers
    FOR UPDATE USING (auth.uid() = user_id);

-- Products table
CREATE TABLE IF NOT EXISTS public.products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('script', 'role', 'subscription', 'one_time')),
    image_url TEXT,
    features TEXT[] DEFAULT ARRAY[]::TEXT[],
    access_config JSONB DEFAULT '{}'::jsonb,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

-- Anyone can read active products
CREATE POLICY "Anyone can read active products" ON public.products
    FOR SELECT USING (is_active = TRUE);

-- Purchases table
CREATE TABLE IF NOT EXISTS public.purchases (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id UUID NOT NULL REFERENCES public.customers(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method TEXT NOT NULL CHECK (payment_method IN ('crypto', 'stripe', 'flutterwave')),
    status TEXT NOT NULL CHECK (status IN ('pending', 'completed', 'failed', 'refunded')) DEFAULT 'pending',
    transaction_hash TEXT,
    network TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    completed_at TIMESTAMPTZ,
    metadata JSONB DEFAULT '{}'::jsonb
);

ALTER TABLE public.purchases ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Customers can read own purchases" ON public.purchases
    FOR SELECT USING (
        customer_id IN (
            SELECT id FROM public.customers WHERE user_id = auth.uid()
        )
    );

-- OAuth tokens table (for storing Discord, Twitter tokens)
CREATE TABLE IF NOT EXISTS public.oauth_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    provider TEXT NOT NULL CHECK (provider IN ('discord', 'twitter')),
    access_token TEXT NOT NULL,
    refresh_token TEXT,
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, provider)
);

ALTER TABLE public.oauth_tokens ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own tokens" ON public.oauth_tokens
    FOR ALL USING (auth.uid() = user_id);

-- TradingView scripts table
CREATE TABLE IF NOT EXISTS public.tradingview_scripts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
    script_id TEXT NOT NULL,
    script_url TEXT NOT NULL,
    version TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    metadata JSONB DEFAULT '{}'::jsonb
);

ALTER TABLE public.tradingview_scripts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read active scripts" ON public.tradingview_scripts
    FOR SELECT USING (is_active = TRUE);

-- Discord roles table
CREATE TABLE IF NOT EXISTS public.discord_roles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
    guild_id TEXT NOT NULL,
    role_id TEXT NOT NULL,
    role_name TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(product_id, guild_id, role_id)
);

ALTER TABLE public.discord_roles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read discord roles" ON public.discord_roles
    FOR SELECT USING (TRUE);

-- Referrals table
CREATE TABLE IF NOT EXISTS public.referrals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    referrer_id UUID NOT NULL REFERENCES public.customers(id) ON DELETE CASCADE,
    referred_id UUID NOT NULL REFERENCES public.customers(id) ON DELETE CASCADE,
    commission_rate DECIMAL(5, 2) DEFAULT 10.00,
    total_earned DECIMAL(10, 2) DEFAULT 0.00,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(referrer_id, referred_id)
);

ALTER TABLE public.referrals ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own referrals" ON public.referrals
    FOR SELECT USING (
        referrer_id IN (
            SELECT id FROM public.customers WHERE user_id = auth.uid()
        )
    );

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_customers_user_id ON public.customers(user_id);
CREATE INDEX IF NOT EXISTS idx_customers_discord_id ON public.customers(discord_id);
CREATE INDEX IF NOT EXISTS idx_customers_twitter_id ON public.customers(twitter_id);
CREATE INDEX IF NOT EXISTS idx_customers_wallet_address ON public.customers(wallet_address);
CREATE INDEX IF NOT EXISTS idx_products_type ON public.products(type);
CREATE INDEX IF NOT EXISTS idx_products_is_active ON public.products(is_active);
CREATE INDEX IF NOT EXISTS idx_purchases_customer_id ON public.purchases(customer_id);
CREATE INDEX IF NOT EXISTS idx_purchases_product_id ON public.purchases(product_id);
CREATE INDEX IF NOT EXISTS idx_purchases_status ON public.purchases(status);
CREATE INDEX IF NOT EXISTS idx_oauth_tokens_user_id ON public.oauth_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_oauth_tokens_provider ON public.oauth_tokens(provider);

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for updated_at
CREATE TRIGGER update_customers_updated_at BEFORE UPDATE ON public.customers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON public.products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_oauth_tokens_updated_at BEFORE UPDATE ON public.oauth_tokens
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tradingview_scripts_updated_at BEFORE UPDATE ON public.tradingview_scripts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
