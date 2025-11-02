-- Seed Data for Flutter SaaS Platform
-- Run this after setting up the main schema to populate with example data

-- Insert example products
INSERT INTO public.products (id, name, description, price, type, image_url, features, access_config, is_active) VALUES
(
    '11111111-1111-1111-1111-111111111111',
    'Premium Trading Signals',
    'Get real-time trading signals powered by advanced algorithms. Includes TradingView script access and Discord alerts.',
    49.99,
    'subscription',
    'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=800',
    ARRAY['Real-time alerts', 'TradingView integration', 'Discord notifications', '24/7 support'],
    '{"discord_role_id": "premium_signals", "tradingview_script_id": "signals_v1"}'::jsonb,
    true
),
(
    '22222222-2222-2222-2222-222222222222',
    'Elite Trader Role',
    'Exclusive Discord role with access to private channels, expert analysis, and community events.',
    29.99,
    'role',
    'https://images.unsplash.com/photo-1639762681485-074b7f938ba0?w=800',
    ARRAY['Private Discord channels', 'Expert market analysis', 'Weekly webinars', 'Priority support'],
    '{"discord_guild_id": "your_guild_id", "discord_role_id": "elite_trader"}'::jsonb,
    true
),
(
    '33333333-3333-3333-3333-333333333333',
    'Advanced Pine Script Pack',
    'Collection of 10+ professional TradingView Pine Scripts for technical analysis and automated trading.',
    99.99,
    'script',
    'https://images.unsplash.com/photo-1642790106117-e829e14a795f?w=800',
    ARRAY['10+ Pine Scripts', 'Lifetime updates', 'Documentation included', 'Email support'],
    '{"tradingview_scripts": ["macd_pro", "rsi_advanced", "volume_profile"]}'::jsonb,
    true
),
(
    '44444444-4444-4444-4444-444444444444',
    'Crypto Analysis Course',
    'Comprehensive video course on cryptocurrency technical analysis and trading strategies.',
    149.99,
    'one_time',
    'https://images.unsplash.com/photo-1621761191319-c6fb62004040?w=800',
    ARRAY['20+ hours of video', 'Downloadable resources', 'Certificate of completion', 'Lifetime access'],
    '{"course_id": "crypto_analysis_101", "platform": "teachable"}'::jsonb,
    true
),
(
    '55555555-5555-5555-5555-555555555555',
    'VIP Membership',
    'All-access pass to every product, service, and feature on the platform.',
    199.99,
    'subscription',
    'https://images.unsplash.com/photo-1634704784915-aacf363b021f?w=800',
    ARRAY['All products included', 'Priority support', 'Early access to new features', 'Monthly 1-on-1 calls'],
    '{"access_level": "vip", "includes_all": true}'::jsonb,
    true
);

-- Insert example Discord roles configuration
INSERT INTO public.discord_roles (product_id, guild_id, role_id, role_name) VALUES
('11111111-1111-1111-1111-111111111111', 'your_guild_id_here', 'premium_signals_role_id', 'Premium Signals'),
('22222222-2222-2222-2222-222222222222', 'your_guild_id_here', 'elite_trader_role_id', 'Elite Trader'),
('55555555-5555-5555-5555-555555555555', 'your_guild_id_here', 'vip_role_id', 'VIP Member');

-- Insert example TradingView scripts
INSERT INTO public.tradingview_scripts (product_id, script_id, script_url, version, is_active, metadata) VALUES
(
    '33333333-3333-3333-3333-333333333333',
    'macd_pro_v1',
    'https://www.tradingview.com/script/example1/',
    '1.0',
    true,
    '{"description": "Advanced MACD indicator with custom settings"}'::jsonb
),
(
    '33333333-3333-3333-3333-333333333333',
    'rsi_advanced_v1',
    'https://www.tradingview.com/script/example2/',
    '1.0',
    true,
    '{"description": "RSI with multiple timeframe analysis"}'::jsonb
),
(
    '11111111-1111-1111-1111-111111111111',
    'signals_v1',
    'https://www.tradingview.com/script/example3/',
    '1.0',
    true,
    '{"description": "Real-time trading signals generator"}'::jsonb
);

-- Note: You'll need to update the guild_id and role_id values with your actual Discord server IDs
-- To get these IDs:
-- 1. Enable Developer Mode in Discord (User Settings > Advanced > Developer Mode)
-- 2. Right-click on your server name and select "Copy ID" for guild_id
-- 3. Right-click on a role and select "Copy ID" for role_id
