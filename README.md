# Bible Fun Quiz Web Deployment

This directory contains the web version of Bible Fun Quiz, including both the Flutter web app and the landing page.

## Project Structure

```
web_app/
├── landing/           # Static landing page files
│   ├── index.html    # Main landing page
│   ├── privacy.html  # Privacy policy page
│   └── images/       # Landing page images
├── lib/              # Flutter app source code
├── web/              # Flutter web-specific files
└── build/            # Generated build files
```

## Deployment Process

The project uses GitHub Actions to automatically deploy to GitHub Pages whenever changes are pushed to the main branch. The deployment process is configured in `.github/workflows/deploy.yml`.

### Deployment Structure

- Landing Page: `https://adriaanbotha.github.io/BibleFunQuiz/`
- Web App: `https://adriaanbotha.github.io/BibleFunQuiz/app/`

### How It Works

1. When code is pushed to the main branch, the GitHub Action workflow:
   - Sets up Flutter environment
   - Copies necessary files to web_app directory
   - Builds the Flutter web app with base href `/BibleFunQuiz/app/`
   - Prepares deployment content:
     * Landing page files go to root directory
     * Flutter web app goes to `/app` directory
   - Deploys to the `gh-pages` branch of the BibleFunQuiz repository

2. The deployment script:
   ```yaml
   - name: Prepare deployment
     run: |
       mkdir -p ./deploy_content
       cp -r web_app/landing/* ./deploy_content/
       mkdir -p ./deploy_content/app
       cp -r web_app/build/web/* ./deploy_content/app/
   ```

3. GitHub Pages serves the content from the `gh-pages` branch

### Important Notes

- The landing page's "Play Now" button links to `/BibleFunQuiz/app/`
- The Flutter app's base href must match the deployment path
- All assets and resources are properly referenced relative to their deployed locations
- The `gh-pages` branch is automatically updated with each deployment

### Manual Deployment

If you need to deploy manually:

1. Build the web app:
   ```bash
   cd web_app
   flutter build web --base-href /BibleFunQuiz/app/ --no-tree-shake-icons --release
   ```

2. Copy the landing page and web app to their respective locations

3. Push to the gh-pages branch:
   ```bash
   git checkout gh-pages
   git add .
   git commit -m "Manual deployment"
   git push origin gh-pages
   ```

### Troubleshooting

If deployment fails:
1. Check the GitHub Actions logs
2. Verify the base href in the Flutter build command
3. Ensure all asset paths are correct
4. Check if the gh-pages branch exists and has the correct permissions 