<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Zakaz-AF | E-commerce Platform for Afghanistan</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #FF6B00;
            --primary-dark: #E55A00;
            --secondary: #128C7E;
            --dark: #1b1b18;
            --light: #FDFDFC;
            --soft-orange: #FFF3E6;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Outfit', sans-serif;
        }

        body {
            background-color: var(--light);
            color: var(--dark);
            overflow-x: hidden;
        }

        .navbar {
            padding: 1.5rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto;
        }

        .logo {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--primary);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .logo-dot {
            width: 12px;
            height: 12px;
            background-color: var(--primary);
            border-radius: 50%;
        }

        .hero {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 6rem 2rem;
            min-height: 80vh;
            background: radial-gradient(circle at top right, var(--soft-orange) 0%, transparent 40%),
                        radial-gradient(circle at bottom left, var(--soft-orange) 0%, transparent 40%);
        }

        .badge {
            background-color: var(--soft-orange);
            color: var(--primary);
            padding: 0.5rem 1rem;
            border-radius: 2rem;
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 2rem;
            display: inline-block;
        }

        h1 {
            font-size: clamp(2.5rem, 8vw, 4.5rem);
            line-height: 1.1;
            margin-bottom: 1.5rem;
            max-width: 900px;
        }

        h1 span {
            color: var(--primary);
        }

        .description {
            font-size: 1.2rem;
            color: #706f6c;
            max-width: 600px;
            margin-bottom: 3rem;
            line-height: 1.6;
        }

        .cta-group {
            display: flex;
            gap: 1.5rem;
            flex-wrap: wrap;
            justify-content: center;
        }

        .btn {
            padding: 1.2rem 2.5rem;
            border-radius: 1rem;
            font-weight: 600;
            font-size: 1.1rem;
            text-decoration: none;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
            box-shadow: 0 10px 30px rgba(255, 107, 0, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(255, 107, 0, 0.4);
            background-color: var(--primary-dark);
        }

        .btn-whatsapp {
            background-color: white;
            color: var(--secondary);
            border: 2px solid #e3e3e0;
        }

        .btn-whatsapp:hover {
            border-color: var(--secondary);
            background-color: #f0fdf4;
        }

        .stats {
            margin-top: 5rem;
            display: flex;
            gap: 4rem;
        }

        .stat-item h3 {
            font-size: 2rem;
            font-weight: 700;
        }

        .stat-item p {
            color: #706f6c;
            font-size: 0.9rem;
        }

        .features-grid {
            max-width: 1200px;
            margin: 0 auto;
            padding: 5rem 2rem;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }

        .feature-card {
            padding: 3rem;
            background: white;
            border-radius: 2rem;
            border: 1px solid #e3e3e0;
            transition: all 0.3s ease;
        }

        .feature-card:hover {
            border-color: var(--primary);
            transform: translateY(-10px);
        }

        .feature-icon {
            width: 60px;
            height: 60px;
            background: var(--soft-orange);
            border-radius: 1.2rem;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 2rem;
        }

        .feature-icon svg {
            width: 30px;
            height: 30px;
            color: var(--primary);
        }

        .feature-card h3 {
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }

        .feature-card p {
            color: #706f6c;
            line-height: 1.6;
        }

        footer {
            padding: 4rem 2rem;
            border-top: 1px solid #e3e3e0;
            text-align: center;
            color: #706f6c;
            font-size: 0.9rem;
        }

        @media (max-width: 768px) {
            h1 { font-size: 3rem; }
            .hero { padding: 4rem 1.5rem; }
            .stats { flex-direction: column; gap: 2rem; }
        }

        /* Float Animation */
        @keyframes float {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
            100% { transform: translateY(0px); }
        }

        .app-preview {
            margin-top: 4rem;
            max-width: 300px;
            filter: drop-shadow(0 30px 60px rgba(0,0,0,0.12));
            animation: float 6s ease-in-out infinite;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <a href="#" class="logo">
            <div class="logo-dot"></div>
            Zakaz-AF
        </a>
    </nav>

    <section class="hero">
        <div class="badge">Version 1.0.5 • Now with Professional WhatsApp Ordering</div>
        <h1>Sell & Buy Smarter in <span>Afghanistan.</span></h1>
        <p class="description">The fastest mobile marketplace for Local Shops and Customers. Connect directly via WhatsApp and grow your business today.</p>
        
        <div class="cta-group">
            <a href="/downloads/zakaz-af-latest.apk" class="btn btn-primary">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                Download for Android
            </a>
            <a href="https://wa.me/93701234567" class="btn btn-whatsapp">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"/></svg>
                Support Center
            </a>
        </div>

        <div class="stats">
            <div class="stat-item">
                <h3>100+</h3>
                <p>Verified Shops</p>
            </div>
            <div class="stat-item">
                <h3>24/7</h3>
                <p>Chat Support</p>
            </div>
            <div class="stat-item">
                <h3>Free</h3>
                <p>To Register</p>
            </div>
        </div>
    </section>

    <section class="features-grid">
        <div class="feature-card">
            <div class="feature-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4H6z"/><path d="M3 6h18"/><path d="M16 10a4 4 0 01-8 0"/></svg>
            </div>
            <h3>Local Shopfronts</h3>
            <p>Create your own shop in seconds and start uploading your products to thousands of customers.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"/></svg>
            </div>
            <h3>WhatsApp Integration</h3>
            <p>No complex checkout processes. Send structured orders directly to the shopkeeper's WhatsApp.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10 13a5 5 0 007.54.54l3-3a5 5 0 00-7.07-7.07l-1.72 1.71"/><path d="M14 11a5 5 0 00-7.54-.54l-3 3a5 5 0 007.07 7.07l1.71-1.71"/></svg>
            </div>
            <h3>Offline Ready</h3>
            <p>Designed for Afghan internal networks. Fast, lightweight, and reliable even on 2G/3G connections.</p>
        </div>
    </section>

    <footer>
        <p>&copy; 2026 Zakaz-AF. Made with ❤️ for Afghanistan.</p>
    </footer>
</body>
</html>
