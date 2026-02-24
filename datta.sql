-- Demo seed data for local presentations and end-to-end validation.
-- Requires schema up to Alembic head (includes roles owner/auditor and admin_audit_log).
--
-- Demo credentials (plaintext on purpose for local demo):
--   demo.owner@finanzas.pe   / OwnerDemo2026!
--   demo.admin@finanzas.pe   / AdminDemo2026!
--   demo.auditor@finanzas.pe / AuditorDemo2026!
--   demo.user1@finanzas.pe   / UserDemo2026!
--   demo.user2@finanzas.pe   / UserDemo2026!
--   demo.user3@finanzas.pe   / UserDemo2026!
--
-- Note: main.py already migrates plaintext passwords to Argon2 on startup.

BEGIN;

INSERT INTO "user" (
    id,
    full_name,
    email,
    password_hash,
    avatar_url,
    role,
    token_pass,
    token_pass_expires,
    token_verification,
    token_verification_expires,
    email_verified,
    is_active,
    created_at,
    updated_at
)
VALUES
(
    '10000000-0000-0000-0000-000000000001',
    'Owner Demo',
    'demo.owner@finanzas.pe',
    'OwnerDemo2026!',
    '/uploads/avatars/demo-owner.png',
    'owner'::user_role,
    NULL,
    NULL,
    NULL,
    NULL,
    true,
    true,
    '2025-11-10 09:00:00',
    '2026-02-24 09:00:00'
),
(
    '10000000-0000-0000-0000-000000000002',
    'Admin Demo',
    'demo.admin@finanzas.pe',
    'AdminDemo2026!',
    '/uploads/avatars/demo-admin.png',
    'admin'::user_role,
    NULL,
    NULL,
    NULL,
    NULL,
    true,
    true,
    '2025-12-05 10:15:00',
    '2026-02-24 09:10:00'
),
(
    '10000000-0000-0000-0000-000000000003',
    'Auditor Demo',
    'demo.auditor@finanzas.pe',
    'AuditorDemo2026!',
    '/uploads/avatars/demo-auditor.png',
    'auditor'::user_role,
    NULL,
    NULL,
    NULL,
    NULL,
    true,
    true,
    '2026-01-03 08:45:00',
    '2026-02-24 09:20:00'
),
(
    '10000000-0000-0000-0000-000000000004',
    'Gaby User Demo',
    'demo.user1@finanzas.pe',
    'UserDemo2026!',
    '/uploads/avatars/demo-user1.png',
    'user'::user_role,
    'seed-reset-token-demo-user1',
    '2026-12-31 23:59:59',
    NULL,
    NULL,
    true,
    true,
    '2026-01-15 14:20:00',
    '2026-02-24 09:30:00'
),
(
    '10000000-0000-0000-0000-000000000005',
    'Mariel User Demo',
    'demo.user2@finanzas.pe',
    'UserDemo2026!',
    '/uploads/avatars/demo-user2.png',
    'user'::user_role,
    NULL,
    NULL,
    NULL,
    NULL,
    true,
    true,
    '2026-02-02 12:00:00',
    '2026-02-24 09:40:00'
),
(
    '10000000-0000-0000-0000-000000000006',
    'Jeff User Demo',
    'demo.user3@finanzas.pe',
    'UserDemo2026!',
    '/uploads/avatars/demo-user3.png',
    'user'::user_role,
    NULL,
    NULL,
    NULL,
    NULL,
    true,
    true,
    '2026-02-14 16:30:00',
    '2026-02-24 09:50:00'
)
ON CONFLICT (email) DO UPDATE
SET
    full_name = EXCLUDED.full_name,
    password_hash = EXCLUDED.password_hash,
    avatar_url = EXCLUDED.avatar_url,
    role = EXCLUDED.role,
    token_pass = EXCLUDED.token_pass,
    token_pass_expires = EXCLUDED.token_pass_expires,
    token_verification = EXCLUDED.token_verification,
    token_verification_expires = EXCLUDED.token_verification_expires,
    email_verified = EXCLUDED.email_verified,
    is_active = EXCLUDED.is_active,
    created_at = EXCLUDED.created_at,
    updated_at = EXCLUDED.updated_at;

INSERT INTO category (
    id,
    name,
    description,
    created_at
)
VALUES
(
    '20000000-0000-0000-0000-000000000001',
    'Alimentacion',
    'Comidas y supermercado',
    '2026-01-01 00:00:00'
),
(
    '20000000-0000-0000-0000-000000000002',
    'Transporte',
    'Movilidad diaria y viajes',
    '2026-01-01 00:00:00'
),
(
    '20000000-0000-0000-0000-000000000003',
    'Servicios',
    'Luz, agua, internet y telefonia',
    '2026-01-01 00:00:00'
),
(
    '20000000-0000-0000-0000-000000000004',
    'Salud',
    'Medicinas, consultas y examenes',
    '2026-01-01 00:00:00'
),
(
    '20000000-0000-0000-0000-000000000005',
    'Educacion',
    'Cursos, talleres y materiales',
    '2026-01-01 00:00:00'
),
(
    '20000000-0000-0000-0000-000000000006',
    'Entretenimiento',
    'Cine, salidas y ocio',
    '2026-01-01 00:00:00'
)
ON CONFLICT (name) DO UPDATE
SET
    description = EXCLUDED.description;

INSERT INTO expense (
    id,
    user_id,
    category_id,
    amount,
    expense_date,
    description,
    created_at,
    updated_at
)
VALUES
(
    '30000000-0000-0000-0000-000000000001',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    28.50,
    '2026-01-03 08:15:00',
    'Desayuno y cafe en la oficina',
    '2026-01-03 08:15:00',
    '2026-01-03 08:15:00'
),
(
    '30000000-0000-0000-0000-000000000002',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    12.00,
    '2026-01-07 09:00:00',
    'Taxi por lluvia',
    '2026-01-07 09:00:00',
    '2026-01-07 09:00:00'
),
(
    '30000000-0000-0000-0000-000000000003',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    130.00,
    '2026-01-12 19:40:00',
    'Pago de internet de casa',
    '2026-01-12 19:40:00',
    '2026-01-12 19:40:00'
),
(
    '30000000-0000-0000-0000-000000000004',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    65.00,
    '2026-01-15 18:05:00',
    'Medicinas para alergia',
    '2026-01-15 18:05:00',
    '2026-01-15 18:05:00'
),
(
    '30000000-0000-0000-0000-000000000005',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    180.70,
    '2026-02-02 20:30:00',
    'Supermercado quincenal',
    '2026-02-02 20:30:00',
    '2026-02-02 20:30:00'
),
(
    '30000000-0000-0000-0000-000000000006',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    95.00,
    '2026-02-10 21:10:00',
    'Curso online de finanzas personales',
    '2026-02-10 21:10:00',
    '2026-02-10 21:10:00'
),
(
    '30000000-0000-0000-0000-000000000007',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    45.20,
    '2026-02-18 08:20:00',
    'Gasolina',
    '2026-02-18 08:20:00',
    '2026-02-18 08:20:00'
),
(
    '30000000-0000-0000-0000-000000000008',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    58.90,
    '2026-02-22 22:00:00',
    'Cine de fin de semana',
    '2026-02-22 22:00:00',
    '2026-02-22 22:00:00'
),
(
    '30000000-0000-0000-0000-000000000009',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    155.00,
    '2026-03-03 11:00:00',
    'Pago de luz y agua',
    '2026-03-03 11:00:00',
    '2026-03-03 11:00:00'
),
(
    '30000000-0000-0000-0000-000000000010',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    22.30,
    '2026-03-05 13:20:00',
    'Almuerzo de oficina',
    '2026-03-05 13:20:00',
    '2026-03-05 13:20:00'
),
(
    '30000000-0000-0000-0000-000000000011',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    240.00,
    '2026-03-18 17:45:00',
    'Consulta odontologica',
    '2026-03-18 17:45:00',
    '2026-03-18 17:45:00'
),
(
    '30000000-0000-0000-0000-000000000012',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    74.80,
    '2026-02-11 20:45:00',
    'Compra semanal de alimentos',
    '2026-02-11 20:45:00',
    '2026-02-11 20:45:00'
),
(
    '30000000-0000-0000-0000-000000000013',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    18.50,
    '2026-02-21 07:55:00',
    'Pasajes de la semana',
    '2026-02-21 07:55:00',
    '2026-02-21 07:55:00'
),
(
    '30000000-0000-0000-0000-000000000014',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    210.00,
    '2026-01-26 19:00:00',
    'Pago de mantenimiento',
    '2026-01-26 19:00:00',
    '2026-01-26 19:00:00'
),
(
    '30000000-0000-0000-0000-000000000015',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    49.90,
    '2026-03-02 21:30:00',
    'Libro de presupuestos',
    '2026-03-02 21:30:00',
    '2026-03-02 21:30:00'
)
ON CONFLICT (id) DO UPDATE
SET
    user_id = EXCLUDED.user_id,
    category_id = EXCLUDED.category_id,
    amount = EXCLUDED.amount,
    expense_date = EXCLUDED.expense_date,
    description = EXCLUDED.description,
    created_at = EXCLUDED.created_at,
    updated_at = EXCLUDED.updated_at;

INSERT INTO access_log (
    id,
    user_id,
    event_type,
    attempt_email,
    created_at,
    ip_address,
    web_agent
)
VALUES
(
    '40000000-0000-0000-0000-000000000001',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    'LOGIN_SUCCESS'::access_event_type,
    'demo.owner@finanzas.pe',
    '2026-02-24 07:00:00',
    '127.0.0.1',
    'Chrome'
),
(
    '40000000-0000-0000-0000-000000000002',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    'LOGIN_SUCCESS'::access_event_type,
    'demo.auditor@finanzas.pe',
    '2026-02-24 07:10:00',
    '127.0.0.1',
    'Firefox'
),
(
    '40000000-0000-0000-0000-000000000003',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    'LOGIN_SUCCESS'::access_event_type,
    'demo.admin@finanzas.pe',
    '2026-02-24 07:30:00',
    '127.0.0.1',
    'Edge'
),
(
    '40000000-0000-0000-0000-000000000004',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    'LOGIN_FAIL'::access_event_type,
    'demo.user1@finanzas.pe',
    '2026-02-23 21:14:00',
    '192.168.1.10',
    'Chrome'
),
(
    '40000000-0000-0000-0000-000000000005',
    NULL,
    'LOGIN_FAIL'::access_event_type,
    'intruso@correo.com',
    '2026-02-23 21:30:00',
    '192.168.1.77',
    'Unknown'
),
(
    '40000000-0000-0000-0000-000000000006',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    'LOGIN_SUCCESS'::access_event_type,
    'demo.user1@finanzas.pe',
    '2026-02-24 08:00:00',
    '127.0.0.1',
    'Chrome'
),
(
    '40000000-0000-0000-0000-000000000007',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    'LOGOUT'::access_event_type,
    'demo.user1@finanzas.pe',
    '2026-02-24 08:45:00',
    '127.0.0.1',
    'Chrome'
),
(
    '40000000-0000-0000-0000-000000000008',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    'PASSWORD_RESET_REQUEST'::access_event_type,
    'demo.user2@finanzas.pe',
    '2026-02-22 16:00:00',
    '127.0.0.1',
    'Safari'
),
(
    '40000000-0000-0000-0000-000000000009',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    'PASSWORD_RESET_SUCCESS'::access_event_type,
    'demo.user2@finanzas.pe',
    '2026-02-22 16:10:00',
    '127.0.0.1',
    'Safari'
),
(
    '40000000-0000-0000-0000-000000000010',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    'EMAIL_VERIFY_SENT'::access_event_type,
    'demo.user3@finanzas.pe',
    '2026-02-14 16:30:00',
    '127.0.0.1',
    'Chrome'
),
(
    '40000000-0000-0000-0000-000000000011',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    'EMAIL_VERIFY_SUCCESS'::access_event_type,
    'demo.user3@finanzas.pe',
    '2026-02-14 16:33:00',
    '127.0.0.1',
    'Chrome'
),
(
    '40000000-0000-0000-0000-000000000012',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    'LOGOUT'::access_event_type,
    'demo.admin@finanzas.pe',
    '2026-02-24 09:00:00',
    '127.0.0.1',
    'Edge'
)
ON CONFLICT (id) DO UPDATE
SET
    user_id = EXCLUDED.user_id,
    event_type = EXCLUDED.event_type,
    attempt_email = EXCLUDED.attempt_email,
    created_at = EXCLUDED.created_at,
    ip_address = EXCLUDED.ip_address,
    web_agent = EXCLUDED.web_agent;

INSERT INTO admin_audit_log (
    id,
    actor_user_id,
    target_user_id,
    target_snapshot_id,
    target_snapshot_name,
    target_snapshot_email,
    action,
    details,
    created_at,
    ip_address,
    web_agent
)
VALUES
(
    '50000000-0000-0000-0000-000000000001',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    'Admin Demo',
    'demo.admin@finanzas.pe',
    'USER_CREATE',
    'role=admin',
    '2026-02-20 10:30:00',
    '127.0.0.1',
    'Chrome'
),
(
    '50000000-0000-0000-0000-000000000002',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    'Mariel User Demo',
    'demo.user2@finanzas.pe',
    'USER_UPDATE',
    'fields=full_name,email',
    '2026-02-21 11:10:00',
    '127.0.0.1',
    'Chrome'
),
(
    '50000000-0000-0000-0000-000000000003',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    'Jeff User Demo',
    'demo.user3@finanzas.pe',
    'USER_UPDATE',
    'fields=password',
    '2026-02-22 15:25:00',
    '127.0.0.1',
    'Edge'
),
(
    '50000000-0000-0000-0000-000000000004',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    NULL,
    '10000000-0000-0000-0000-000000000099',
    'Deleted User Demo',
    'deleted.user@finanzas.pe',
    'USER_DELETE',
    'deleted_role=user',
    '2026-02-23 12:00:00',
    '127.0.0.1',
    'Chrome'
)
ON CONFLICT (id) DO UPDATE
SET
    actor_user_id = EXCLUDED.actor_user_id,
    target_user_id = EXCLUDED.target_user_id,
    target_snapshot_id = EXCLUDED.target_snapshot_id,
    target_snapshot_name = EXCLUDED.target_snapshot_name,
    target_snapshot_email = EXCLUDED.target_snapshot_email,
    action = EXCLUDED.action,
    details = EXCLUDED.details,
    created_at = EXCLUDED.created_at,
    ip_address = EXCLUDED.ip_address,
    web_agent = EXCLUDED.web_agent;

COMMIT;
