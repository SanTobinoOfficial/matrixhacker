function Get-LearningContent-webdev {
    param([string]$Difficulty = "beginner")

    $fs = @{
        home = @{ Type = "dir"; Owner = "dev"; Group = "dev"; Children = @{
            dev = @{ Type = "dir"; Owner = "dev"; Group = "dev"; Children = @{
                package_json = @{ Type = "file"; Owner = "dev"; Group = "dev"; Content = @(
                    '{', '  "name": "my-react-app",', '  "version": "1.0.0",', '  "private": true,',
                    '  "main": "src/index.js",', '  "scripts": {', '    "start": "webpack serve --mode development",',
                    '    "build": "webpack --mode production"', '  },', '  "dependencies": {',
                    '    "react": "^18.2.0",', '    "react-dom": "^18.2.0"', '  },', '  "devDependencies": {',
                    '    "@babel/core": "^7.23.0",', '    "@babel/preset-env": "^7.23.0",',
                    '    "@babel/preset-react": "^7.22.0",', '    "webpack": "^5.89.0",',
                    '    "webpack-cli": "^5.1.0",', '    "babel-loader": "^9.1.0",',
                    '    "css-loader": "^6.8.0",', '    "style-loader": "^3.3.0",',
                    '    "html-webpack-plugin": "^5.5.0"', '  }', '}'
                )}
                webpack_config_js = @{ Type = "file"; Owner = "dev"; Group = "dev"; Content = @(
                    "const path = require('path');",
                    "const HtmlWebpackPlugin = require('html-webpack-plugin');",
                    "module.exports = {",
                    "  entry: './src/index.js',",
                    "  output: { path: path.resolve(__dirname, 'dist'), filename: 'bundle.js' },",
                    "  module: {",
                    "    rules: [",
                    "      { test: /\.(js|jsx)$/, exclude: /node_modules/, use: 'babel-loader' },",
                    "      { test: /\.css$/, use: ['style-loader', 'css-loader'] }",
                    "    ]",
                    "  },",
                    "  resolve: { extensions: ['.js', '.jsx'] },",
                    "  plugins: [new HtmlWebpackPlugin({ template: './public/index.html' })]",
                    "};"
                )}
                babelrc = @{ Type = "file"; Owner = "dev"; Group = "dev"; Content = @(
                    '{', '  "presets": [',
                    '    ["@babel/preset-env", { "targets": { "browsers": ["last 2 versions"] } }],',
                    '    ["@babel/preset-react", { "runtime": "automatic" }]', '  ]', '}'
                )}
                eslintrc_json = @{ Type = "file"; Owner = "dev"; Group = "dev"; Content = @(
                    '{', '  "env": { "browser": true, "es2021": true, "node": true, "jest": true },',
                    '  "extends": ["eslint:recommended", "plugin:react/recommended"],',
                    '  "parserOptions": { "ecmaVersion": "latest", "sourceType": "module" },',
                    '  "rules": { "react/react-in-jsx-scope": "off" }', '}'
                )}
                gitignore = @{ Type = "file"; Owner = "dev"; Group = "dev"; Content = @(
                    "node_modules/", "dist/", ".env", "*.log", ".DS_Store", "coverage/"
                )}
                README_md = @{ Type = "file"; Owner = "dev"; Group = "dev"; Content = @(
                    "# My React App", "A web application built with React 18 and Webpack 5.",
                    "## Available Scripts", "- npm start - runs dev server on port 3000",
                    "- npm run build - builds for production"
                )}
                src = @{ Type = "dir"; Owner = "dev"; Group = "dev"; Children = @{
                    index_js = @{ Type = "file"; Owner = "dev"; Group = "dev"; Content = @(
                        "import React from 'react';",
                        "import ReactDOM from 'react-dom/client';",
                        "import App from './App';",
                        "const root = ReactDOM.createRoot(document.getElementById('root'));",
                        "root.render(React.createElement(React.StrictMode, null, React.createElement(App)));"
                    )}
                    App_js = @{ Type = "file"; Owner = "dev"; Group = "dev"; Content = @(
                        "import React, { useState } from 'react';",
                        "function App() {",
                        "  const [count, setCount] = useState(0);",
                        "  return React.createElement('div', { className: 'app' },",
                        "    React.createElement('h1', null, 'Welcome to My React App'),",
                        "    React.createElement('p', null, 'You clicked ' + count + ' times'),",
                        "    React.createElement('button', { onClick: () => setCount(count + 1) }, 'Click me')",
                        "  );",
                        "}",
                        "export default App;"
                    )}
                    components = @{ Type = "dir"; Owner = "dev"; Group = "dev"; Children = @{ 
                        Header_jsx = @{ Type = "file"; Owner = "dev"; Group = "dev"; Content = @(
                            "import React from 'react';",
                            "function Header({ title }) {",
                            "  return React.createElement('nav', { className: 'navbar' }, title);",
                            "}",
                            "export default Header;"
                        )}
                    }}
                    styles = @{ Type = "dir"; Owner = "dev"; Group = "dev"; Children = @{
                        main_css = @{ Type = "file"; Owner = "dev"; Group = "dev"; Content = @(
                            "* { margin: 0; padding: 0; box-sizing: border-box; }",
                            "body { font-family: -apple-system, sans-serif; background: #f5f5f5; }",
                            ".app { text-align: center; padding: 2rem; }",
                            "h1 { color: #333; margin-bottom: 1rem; }",
                            "button { background: #61dafb; border: none; padding: 0.5rem 1rem; }"
                        )}
                    }}
                }}
                public = @{ Type = "dir"; Owner = "dev"; Group = "dev"; Children = @{
                    index_html = @{ Type = "file"; Owner = "dev"; Group = "dev"; Content = @(
                        '<!DOCTYPE html>', '<html lang="en">', '<head>',
                        '<meta charset="UTF-8">',
                        '<meta name="viewport" content="width=device-width, initial-scale=1.0">',
                        '<title>My React App</title>', '</head>', '<body>',
                        '<div id="root"></div>', '</body>', '</html>'
                    )}
                    favicon_ico = @{ Type = "file"; Owner = "dev"; Group = "dev"; Content = @("(icon data)")}
                }}
                dist = @{ Type = "dir"; Owner = "dev"; Group = "dev"; Children = @{
                    bundle_js = @{ Type = "file"; Owner = "dev"; Group = "dev"; Content = @(
                        "(function(){'use strict';console.log('App bundle loaded');})();"
                    )}
                }}
                node_modules = @{ Type = "dir"; Owner = "dev"; Group = "dev"; Children = @{
                    react = @{ Type = "dir"; Owner = "dev"; Group = "dev"; Children = @{
                        package_json = @{ Type = "file"; Owner = "dev"; Group = "dev"; Content = @("{}")}
                    }}
                }}
                tests = @{ Type = "dir"; Owner = "dev"; Group = "dev"; Children = @{
                    App_test_js = @{ Type = "file"; Owner = "dev"; Group = "dev"; Content = @(
                        "import { render, screen } from '@testing-library/react';",
                        "import App from '../src/App';",
                        "test('renders welcome heading', () => {",
                        "  render(React.createElement(App));",
                        "});"
                    )}
                }}
            }}
        }}
        etc = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            hostname = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @("dev-machine")}
            nginx = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                sites_available = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                    default = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                        "server {", "    listen 80 default_server;",
                        "    root /var/www/html;", "    index index.html index.htm;",
                        "    server_name _;",
                        '    location / { try_files $uri $uri/ =404; }',
                        "    location ~* \\.(jpg|png|css|js)$ { expires 30d; }",
                        "    access_log /var/log/nginx/access.log;",
                        "    error_log /var/log/nginx/error.log;", "}"
                    )}
                }}
                sites_enabled = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{}}
            }}
            os_release = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                'PRETTY_NAME="Ubuntu 24.04 LTS (Dev Machine)"', 'NAME="Ubuntu"',
                "VERSION_ID=24.04", "ID=ubuntu"
            )}
        }}
        var = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            log = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                nginx = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                    access_log = @{ Type = "file"; Owner = "root"; Group = "adm"; Content = @(
                        '192.168.1.50 - - [08/Jun/2026:08:15:23 +0000] "GET / HTTP/1.1" 200 612',
                        '192.168.1.50 - - [08/Jun/2026:08:15:24 +0000] "GET /styles/main.css HTTP/1.1" 200 312',
                        '192.168.1.52 - - [08/Jun/2026:08:25:00 +0000] "GET /api/users HTTP/1.1" 404 153',
                        '192.168.1.50 - - [08/Jun/2026:08:30:00 +0000] "POST /api/login HTTP/1.1" 200 85',
                        '10.0.0.99 - - [08/Jun/2026:08:35:00 +0000] "GET /admin HTTP/1.1" 404 153',
                        '192.168.1.53 - - [08/Jun/2026:09:00:00 +0000] "GET / HTTP/1.1" 200 612'
                    )}
                    error_log = @{ Type = "file"; Owner = "root"; Group = "adm"; Content = @(
                        "2026/06/08 08:25:00 [error] 1234#1234: *1 open() failed (2: No such file)",
                        "2026/06/08 08:35:00 [warn] 1234#1234: *2 client closed connection"
                    )}
                }}
            }}
            www = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                html = @{ Type = "dir"; Owner = "www-data"; Group = "www-data"; Children = @{
                    index_html = @{ Type = "file"; Owner = "www-data"; Group = "www-data"; Content = @(
                        '<!DOCTYPE html>', '<html>', '<head><title>Welcome!</title></head>',
                        '<body><h1>Welcome to nginx!</h1></body>', '</html>'
                    )}
                }}
            }}
        }}
        usr = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            local = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                bin = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{}}
            }}
        }}
        tmp = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{}}
    }

    $beginnerTasks = @(
        @{ Id = "web-b1"; Title = "List all files in project"; Difficulty = "beginner"; ExpectedCommand = "ls -la"; Description = @("List all files in the home directory of the dev user, including hidden config files."); Hint = "Use: ls -la" }
        @{ Id = "web-b2"; Title = "Read package.json"; Difficulty = "beginner"; ExpectedCommand = "cat package_json"; Description = @("Display the contents of package.json to see project dependencies and scripts."); Hint = "Use: cat package_json" }
        @{ Id = "web-b3"; Title = "View the README"; Difficulty = "beginner"; ExpectedCommand = "cat README_md"; Description = @("Read the README.md file to learn about the project."); Hint = "Use: cat README_md" }
        @{ Id = "web-b4"; Title = "Explore source files"; Difficulty = "beginner"; ExpectedCommand = "ls src/"; Description = @("List the contents of the src directory to see the source code files."); Hint = "Use: ls src/" }
        @{ Id = "web-b5"; Title = "View the public HTML"; Difficulty = "beginner"; ExpectedCommand = "cat public/index_html"; Description = @("Display the index.html template in the public directory."); Hint = "Use: cat public/index_html" }
    )

    $intermediateTasks = @(
        @{ Id = "web-i1"; Title = "Check Webpack config"; Difficulty = "intermediate"; ExpectedCommand = "cat webpack_config_js"; Description = @("Display the Webpack configuration to understand how the project is built."); Hint = "Use: cat webpack_config_js" }
        @{ Id = "web-i2"; Title = "View ESLint config"; Difficulty = "intermediate"; ExpectedCommand = "cat eslintrc_json"; Description = @("Check the ESLint configuration for code style rules."); Hint = "Use: cat eslintrc_json" }
        @{ Id = "web-i3"; Title = "Search for dependencies"; Difficulty = "intermediate"; ExpectedCommand = "grep 'react' package_json"; Description = @("Find all lines mentioning 'react' in package.json."); Hint = "Use: grep 'react' package_json" }
        @{ Id = "web-i4"; Title = "Check the nginx config"; Difficulty = "intermediate"; ExpectedCommand = "cat /etc/nginx/sites_available/default"; Description = @("Display the nginx site configuration for the dev server."); Hint = "Use: cat /etc/nginx/sites_available/default" }
        @{ Id = "web-i5"; Title = "Check the .gitignore"; Difficulty = "intermediate"; ExpectedCommand = "cat gitignore"; Description = @("Display the .gitignore file to see what is excluded from version control."); Hint = "Use: cat gitignore" }
    )

    $advancedTasks = @(
        @{ Id = "web-a1"; Title = "Find all JS files"; Difficulty = "advanced"; ExpectedCommand = "find /home/dev -name '*.js' -not -path '*/node_modules/*'"; Description = @("Find all JavaScript source files in the project, excluding node_modules."); Hint = "Use: find /home/dev -name '*.js' -not -path '*/node_modules/*'" }
        @{ Id = "web-a2"; Title = "Search nginx error log"; Difficulty = "advanced"; ExpectedCommand = "grep 'error' /var/log/nginx/error_log"; Description = @("Check the nginx error log for any server issues."); Hint = "Use: grep 'error' /var/log/nginx/error_log" }
        @{ Id = "web-a3"; Title = "Find 404 responses in access log"; Difficulty = "advanced"; ExpectedCommand = "grep ' 404 ' /var/log/nginx/access_log"; Description = @("Search the nginx access log for all 404 responses."); Hint = "Use: grep ' 404 ' /var/log/nginx/access_log" }
        @{ Id = "web-a4"; Title = "Check hostname"; Difficulty = "advanced"; ExpectedCommand = "cat /etc/hostname"; Description = @("Display the hostname of the dev machine."); Hint = "Use: cat /etc/hostname" }
        @{ Id = "web-a5"; Title = "List nginx sites"; Difficulty = "advanced"; ExpectedCommand = "ls /etc/nginx/sites_enabled/"; Description = @("List the enabled nginx sites."); Hint = "Use: ls /etc/nginx/sites_enabled/" }
    )

    $expertTasks = @(
        @{ Id = "web-e1"; Title = "Count HTTP status codes"; Difficulty = "expert"; ExpectedCommand = 'grep " 404 " /var/log/nginx/access_log'; Description = @("Find all HTTP 404 responses in the nginx access log and count them."); Hint = 'Use: grep " 404 " /var/log/nginx/access_log' }
        @{ Id = "web-e2"; Title = "Backup project"; Difficulty = "expert"; ExpectedCommand = "tar -czf project_backup.tar.gz -C /home/dev --exclude=node_modules ."; Description = @("Create a gzipped archive of the project excluding node_modules."); Hint = "Use: tar -czf project_backup.tar.gz -C /home/dev --exclude=node_modules ." }
        @{ Id = "web-e3"; Title = "Find all JSON config files"; Difficulty = "expert"; ExpectedCommand = 'find /home/dev -name "*.json"'; Description = @("Locate all JSON configuration files in the project."); Hint = 'Use: find /home/dev -name "*.json"' }
        @{ Id = "web-e4"; Title = "Extract dependency versions"; Difficulty = "expert"; ExpectedCommand = "grep -E '\\^|~' /home/dev/package_json | head -10"; Description = @("Extract version strings from package.json to audit dependencies."); Hint = "Use: grep -E '\\^|~' /home/dev/package_json | head -10" }
        @{ Id = "web-e5"; Title = "Check node_modules size"; Difficulty = "expert"; ExpectedCommand = "du -sh /home/dev/node_modules"; Description = @("Calculate the total disk space used by node_modules."); Hint = "Use: du -sh /home/dev/node_modules" }
    )

    $tasks = @()
    switch ($Difficulty) {
        "beginner" { $tasks = $beginnerTasks }
        "intermediate" { $tasks = $intermediateTasks }
        "advanced" { $tasks = $advancedTasks }
        "expert" { $tasks = $expertTasks }
        default { $tasks = $beginnerTasks }
    }
    return @{ Filesystem = $fs; Tasks = $tasks }
}
