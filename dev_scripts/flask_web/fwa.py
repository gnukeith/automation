import os
import shutil

def create_directory_structure(base_dir, dir_name, stage):
    try:
        full_dir_path = os.path.join(base_dir, dir_name)
        
        # Check if directory already exists
        if os.path.exists(full_dir_path):
            user_choice = input(f"The directory '{dir_name}' already exists. Do you want to replace it? (y/n): ").strip().lower()
            if user_choice == 'y':
                shutil.rmtree(full_dir_path)
                os.makedirs(full_dir_path)
            else:
                full_dir_path = os.path.join(base_dir, f"{dir_name}1")
                os.makedirs(full_dir_path)
        else:
            os.makedirs(full_dir_path)
        
        # Common files
        with open(os.path.join(full_dir_path, 'readme.md'), 'w') as f:
            pass

        with open(os.path.join(full_dir_path, 'requirements.txt'), 'w') as f:
            f.write("flask\n")

        with open(os.path.join(full_dir_path, 'app.py'), 'w') as f:
            app_code = """
from flask import Flask, render_template, abort

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.errorhandler(404)
def not_found_error(error):
    return render_template('404.html'), 404

@app.errorhandler(500)
def internal_error(error):
    return render_template('500.html'), 500

if __name__ == '__main__':
    app.run(debug=True)
            """
            f.write(app_code.strip())

        os.makedirs(os.path.join(full_dir_path, 'templates'), exist_ok=True)
        os.makedirs(os.path.join(full_dir_path, 'static', 'img'), exist_ok=True)
        os.makedirs(os.path.join(full_dir_path, 'static', 'js'), exist_ok=True)
        os.makedirs(os.path.join(full_dir_path, 'static', 'css'), exist_ok=True)
        
        framework = input("Do you want to use a CSS framework? (none/tailwind/bootstrap): ").strip().lower()
        framework_link = ""
        if framework == "tailwind":
            framework_link = '<script src="https://cdn.tailwindcss.com"></script>'
        elif framework == "bootstrap":
            framework_link = '<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">'
        
        if stage == 'full':
            # Creating error and footer pages
            error_404_html = f"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    {framework_link}
    <title>404 Not Found</title>
</head>
<body>
    <h1>404 Not Found</h1>
    <p>Oops! The page you are looking for doesn't exist.</p>
    <a href="/">Return Home</a>
</body>
</html>
            """
            with open(os.path.join(full_dir_path, 'templates', '404.html'), 'w') as f:
                f.write(error_404_html)

            error_500_html = f"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    {framework_link}
    <title>500 Internal Server Error</title>
</head>
<body>
    <h1>500 Internal Server Error</h1>
    <p>Sorry, something went wrong on our end.</p>
    <a href="/">Return Home</a>
</body>
</html>
            """
            with open(os.path.join(full_dir_path, 'templates', '500.html'), 'w') as f:
                f.write(error_500_html)

            with open(os.path.join(full_dir_path, 'templates', 'footer.html'), 'w') as f:
                f.write("""
<div class="footer">
    <p>Copyright &copy; 2024</p>
</div>
                """)
        
        # Index.html and CSS for any stage
        index_html = f"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/static/css/style.css">
    {framework_link}
    <title>Home Page</title>
</head>
<body>
    <h1>Welcome to the Home Page!</h1>
    {{% include 'footer.html' %}}
</body>
</html>
        """
        with open(os.path.join(full_dir_path, 'templates', 'index.html'), 'w') as f:
            f.write(index_html)
        
        with open(os.path.join(full_dir_path, 'static', 'css', 'style.css'), 'w') as f:
            pass

        print(f"Everything is set. Go to {full_dir_path} to see your setup.")

    except Exception as e:
        print(f"An error occurred: {e}")

base_dir = input("Enter base directory: ")
dir_name = input("Enter directory name: ")
stage = input("Enter stage (basic or full): ")
create_directory_structure(base_dir, dir_name, stage)
