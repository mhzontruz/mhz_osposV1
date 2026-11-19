# Running OSPOS Locally on Windows

This project is an Open Source Point of Sale application that uses PHP,
CodeIgniter 4, Nginx, and MySQL.

## Verified environment

- Project directory: `D:\nginx\html\ospos`
- Nginx executable: `D:\nginx\nginx.exe`
- Nginx public root: `D:\nginx\html\ospos\public`
- PHP executable: `C:\Program Files\PHP\8.5.12-1\ts\x64\php-cgi.exe`
- PHP configuration: `C:\Program Files\PHP\current\php.ini`
- PHP extension directory:
  `C:\Program Files\PHP\8.5.12-1\ts\x64\ext`
- Nginx configuration: `D:\nginx\conf\nginx.conf`
- PHP-FastCGI address: `127.0.0.1:9000`
- Website address: `http://localhost`
- Login address: `http://localhost/login`
- Database service: `MySQL80`
- PHP version: `8.5.12`

## Summary of problems found

1. PHP was installed, but the required `intl` extension was disabled.
   The application failed before routing because `Locale` was missing.
2. The PHP configuration was commented as `;extension=intl`.
3. PHP CLI and PHP-CGI needed the required database and locale extensions.
   `mysqli` and `pdo_mysql` were available, and `intl` was available as
   `C:\Program Files\PHP\8.5.12-1\ts\x64\ext\php_intl.dll`.
4. Nginx was not initially running.
5. PHP-FastCGI was not initially running on port `9000`.
6. The application needs MySQL to be running.
7. The project `.env` already allows `localhost` through
   `app.allowedHostnames='localhost'`.
8. The project `.env` contains database connection settings and should be
   reviewed before deployment. Database passwords and encryption secrets must
   not be shared or committed.
9. The initial root `HEAD` request returned `404`, but the application route
   is working: `/` redirects to `/login`, and `/login` returns HTTP `200`.
10. The login page reported database migration state when migrations were
    pending. It is normal to initialize or migrate through the login page.

## 1. Open a PowerShell terminal

Run commands from an elevated PowerShell terminal for service installation or
configuration changes. Normal project startup commands do not need
administrator rights.

## 2. Verify PHP

```powershell
php -v
php --ini
```

Verify the required PHP modules:

```powershell
php -d extension=intl -r "echo extension_loaded('intl') ? 'intl=yes' : 'intl=no'; echo PHP_EOL;"
php -d extension=intl -r "echo extension_loaded('mysqli') ? 'mysqli=yes' : 'mysqli=no'; echo PHP_EOL;"
php -d extension=intl -r "echo extension_loaded('pdo_mysql') ? 'pdo_mysql=yes' : 'pdo_mysql=no'; echo PHP_EOL;"
```

The result should include:

```text
intl=yes
mysqli=yes
pdo_mysql=yes
```

The supported PHP version requirement is PHP `8.2.35+`, `8.3.36+`,
`8.4.27+`, or `8.5.12+` for the corresponding supported PHP branch.

## 3. Enable `intl` permanently

The DLL exists at:

```text
C:\Program Files\PHP\8.5.12-1\ts\x64\ext\php_intl.dll
```

Open `C:\Program Files\PHP\current\php.ini` in an elevated editor and change:

```ini
;extension=intl
```

to:

```ini
extension=intl
```

Save the file and verify:

```powershell
php -r "echo extension_loaded('intl') ? 'intl=yes' : 'intl=no'; echo PHP_EOL;"
```

If the configuration file cannot be edited because of permissions, use the
verified startup command below with `-d extension=intl` instead.

## 4. Verify MySQL

Check the service:

```powershell
Get-Service MySQL80
```

Start it if it is stopped:

```powershell
Start-Service MySQL80
```

Check the port:

```powershell
Test-NetConnection localhost -Port 3306 -InformationLevel Quiet
```

The result should be `True`.

## 5. Configure the project

The project already has a `.env` file at:

```text
D:\nginx\html\ospos\.env
```

Confirm that it contains local hostname protection:

```env
CI_ENVIRONMENT=production
app.allowedHostnames='localhost'
```

Check the `database.default` section and ensure it points to a valid MySQL
database and user. Do not publish the database password or secrets from
`.env`.

For a fresh configuration, copy `.env.example` to `.env`, then update the
database settings:

```powershell
Set-Location D:\nginx\html\ospos
Copy-Item .env.example .env
```

This is not required in the current installation because `.env` already exists.

The database name and prefix should correspond to the application setup. The
prefix must be configured correctly and must not be added to table names in
code.

## 6. Install dependencies

Dependencies are already present, but repeat these commands after a fresh
checkout:

```powershell
Set-Location D:\nginx\html\ospos
composer install
npm install
npm run build
```

The current project has both `vendor/autoload.php` and
`node_modules/.bin/gulp.cmd`.

## 7. Verify application routes

Run this with `intl` enabled:

```powershell
Set-Location D:\nginx\html\ospos
php -d extension=intl spark routes
```

The routes should include `/` and `/login`.

## 8. Start PHP-FastCGI

Start PHP-CGI on the address configured by Nginx:

```powershell
& 'C:\Program Files\PHP\8.5.12-1\ts\x64\php-cgi.exe' `
  -c 'C:\Program Files\PHP\current\php.ini' `
  -d extension=intl `
  -d extension_dir='C:\Program Files\PHP\8.5.12-1\ts\x64\ext' `
  -b 127.0.0.1:9000
```

For a repeatable process, run this command in a separate PowerShell window.
Keep that window open. Use an asynchronous detached process only when you
intend to leave PHP running in the background.

Verify port `9000`:

```powershell
Test-NetConnection localhost -Port 9000 -InformationLevel Quiet
```

The result should be `True`.

## 9. Configure Nginx

The relevant server block in `D:\nginx\conf\nginx.conf` should contain:

```nginx
server {
    listen 80;
    server_name localhost;
    root "D:\nginx\html\ospos\public";
    index index.php;
    client_max_body_size 10M;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        try_files $uri =404;
        include fastcgi_params;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }

    location ~ /\. {
        deny all;
    }
}
```

Windows Nginx configuration paths may use backslashes as shown above. Use
PowerShell-style backslashes consistently when editing Windows paths.

## 10. Start Nginx

Test the configuration before starting:

```powershell
Set-Location D:\nginx
.\nginx.exe -t
```

Start Nginx:

```powershell
Set-Location D:\nginx
.\nginx.exe
```

If Nginx is already running, reload it:

```powershell
Set-Location D:\nginx
.\nginx.exe -s reload
```

Verify port `80`:

```powershell
Test-NetConnection localhost -Port 80 -InformationLevel Quiet
```

The result should be `True`.

## 11. Open the application

Open:

```text
http://localhost
```

The root route redirects to:

```text
http://localhost/login
```

If the database needs initialization or migration, use the login page controls
and enter the administrator credentials requested by the migration UI.

For an installed database, the standard login is normally:

```text
Username: admin
Password: pointofsale
```

Change the default password after the first successful login.

## 12. Verify the running services

Check PHP-CGI and Nginx processes:

```powershell
Get-Process php-cgi,nginx -ErrorAction SilentlyContinue |
    Select-Object ProcessName,Id
```

Check MySQL:

```powershell
Get-Service MySQL80
```

Check HTTP responses:

```powershell
curl.exe -i --max-time 10 http://localhost/
curl.exe -i --max-time 10 http://localhost/login
```

Expected results:

- `/`: HTTP `302` with `Location: http://localhost/login`
- `/login`: HTTP `200`
- Nginx is listening on port `80`
- PHP-CGI is listening on port `9000`
- MySQL is in `Running` state

## 13. Quick restart procedure

After a reboot or if the services stop, run these steps:

```powershell
Start-Service MySQL80

& 'C:\Program Files\PHP\8.5.12-1\ts\x64\php-cgi.exe' `
  -c 'C:\Program Files\PHP\current\php.ini' `
  -d extension=intl `
  -d extension_dir='C:\Program Files\PHP\8.5.12-1\ts\x64\ext' `
  -b 127.0.0.1:9000

Set-Location D:\nginx
.\nginx.exe
```

Keep the PHP-CGI window open while using the application.

Open `http://localhost/login` in a browser.

## 14. Stop the services

Stop Nginx:

```powershell
Set-Location D:\nginx
.\nginx.exe -s stop
```

Stop PHP-CGI by its process ID only:

```powershell
Get-Process php-cgi
Stop-Process -Id <php-cgi-PID>
```

Do not use a name-based process-killing command.

Stop MySQL if it is not needed by other applications:

```powershell
Stop-Service MySQL80
```

## 15. Troubleshooting

### `Class "Locale" not found`

This means `intl` is missing or disabled.

1. Confirm `php_intl.dll` exists.
2. Enable `extension=intl` in `php.ini`.
3. Restart PHP-CGI.
4. Verify with `php -d extension=intl -r "echo class_exists('Locale') ? 'yes' : 'no';"`.

### `Security: allowedHostnames is not configured`

Add this to `.env`:

```env
app.allowedHostnames='localhost'
```

For a production domain, replace `localhost` with the actual domain and
subdomains. Do not include protocol or port numbers.

### Database connection failure

1. Start MySQL.
2. Verify port `3306`.
3. Verify the database name, username, password, prefix, and hostname in
   `.env`.
4. Ensure the configured database account can access the configured database.

### HTTP `404` at `/`

Check:

- Nginx points to `D:\nginx\html\ospos\public`
- PHP-FastCGI is listening on `127.0.0.1:9000`
- `location /` includes the `try_files` rule
- `/login` is registered and `/login` returns HTTP `200`

A `404` for `/favicon.ico` does not prevent login from loading.

### PHP-CGI will not start

Check that port `9000` is not already in use:

```powershell
Get-NetTCPConnection -LocalPort 9000 -State Listen -ErrorAction SilentlyContinue
```

Stop or relocate the existing PHP-CGI process, then start PHP-CGI again.

### Nginx will not start

Validate the configuration:

```powershell
Set-Location D:\nginx
.\nginx.exe -t
```

Check whether port `80` is already occupied:

```powershell
Get-NetTCPConnection -LocalPort 80 -State Listen -ErrorAction SilentlyContinue
```

Resolve the port conflict or stop the conflicting service.

### Migration or initialization warning

The login page can initialize or migrate the database. If prompted:

1. Open `/login`.
2. Enter valid administrator credentials.
3. Submit the migration action.
4. Wait until the migration status completes successfully.
5. Log in again.
