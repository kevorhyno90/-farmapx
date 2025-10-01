
import http.server
import socketserver
import os
import mimetypes

PORT = 8000

class CORSRequestHandler(http.server.BaseHTTPRequestHandler):
    def do_OPTIONS(self):
        self.send_response(204)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'X-Requested-With, Content-Type')
        self.end_headers()

    def do_GET(self):
        # Determine the file path
        if self.path == '/':
            filepath = 'index.html'
        else:
            filepath = self.path.lstrip('/')

        # Check if the file exists and is a file
        if not os.path.isfile(filepath):
            filepath = 'index.html'

        if not os.path.isfile(filepath):
            self.send_error(404, "File not found")
            return

        # Read the file content
        try:
            with open(filepath, 'rb') as f:
                content = f.read()
        except IOError:
            self.send_error(500, "Error reading file")
            return

        # Guess the MIME type
        mimetype, _ = mimetypes.guess_type(filepath)
        if mimetype is None:
            mimetype = 'application/octet-stream'

        # Send response
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Content-type', mimetype)
        self.send_header('Content-Length', str(len(content)))
        self.end_headers()

        # Write content
        self.wfile.write(content)

# Set the working directory to the script's directory
os.chdir(os.path.dirname(os.path.abspath(__file__)))

with socketserver.TCPServer(("", PORT), CORSRequestHandler) as httpd:
    print(f"Serving at http://localhost:{PORT}")
    print("Custom CORS-enabled server is running.")
    print("To run the server, execute: python3 server.py")
    httpd.serve_forever()
