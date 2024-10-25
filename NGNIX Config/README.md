# Nginx Reverse Proxy Management Script

This script allows you to manage Nginx reverse proxy configurations on a remote server. You can create new configurations and remove existing ones, including the option to delete associated SSL certificates and keys.

## Features

- Create a new reverse proxy site configuration.
- Delete an existing reverse proxy site configuration.
- Optionally delete SSL certificates and keys associated with the site.

## Prerequisites

- A remote server with Nginx installed.
- SSH access to the remote server.
- The necessary permissions to modify Nginx configurations.

## Usage

### Adding a Reverse Proxy Configuration

To add a new reverse proxy configuration, use the following command:

```bash
./add-nginx-proxy-remote.sh <remote_user>@<remote_host> <domain>
```

Parameters:

<remote_user>@<remote_host>: The SSH login credentials to the remote server (e.g., user@192.168.1.10).
<domain>: The domain name for the reverse proxy configuration you want to create (e.g., example.com).

### Deleting a Reverse Proxy Configuration

To delete an existing reverse proxy configuration, use the following command:

```bash
./delete-nginx-proxy-remote.sh <remote_user>@<remote_host> <domain>
```

Parameters:

<remote_user>@<remote_host>: The SSH login credentials to the remote server (e.g., user@192.168.1.10).
<domain>: The domain name associated with the reverse proxy configuration you want to delete (e.g., example.com)

### Example

Adding a configuration:

```bash
./add-nginx-proxy-remote.sh user@remote_ip example.com
```

Deleting a configuration:

```bash
./delete-nginx-proxy-remote.sh user@remote_ip example.com
```

### Deletion Process
- The script checks if the specified configuration exists.
- If it exists, it prompts the user to confirm the deletion of the SSL certificate and key.
- It removes the Nginx configuration and, if confirmed, the associated SSL files.
- Finally, it tests the Nginx configuration and reloads it if the test is successful.

### Important Notes
- Ensure that you have a backup of any important configuration files before running the script.
- The script must be run in a Unix-like environment (Linux or macOS) with access to bash and SSH.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.