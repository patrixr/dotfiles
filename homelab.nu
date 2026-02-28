use glue *

group "Homelab" {
  return # disabled

  let ip = "192.168.1.103"
  let user = "pi"

  if (sshable $ip) {
    let pw = input ":: Pi password: " --suppress-output
    let remote_file = "/tmp/homelab.yml"
    let host = $"($user)@($ip)"

    sshpass -p $pw ssh $host  'command -v docker >/dev/null 2>&1 || curl -fsSL https://get.docker.com | bash'
    sshpass -p $pw scp $"($env.FILE_PWD)/homelab.env" $"($host):/home/pi/homelab.env"
    sshpass -p $pw scp $"($env.FILE_PWD)/homelab.yml" $"($host):/home/pi/homelab.yml"
    sshpass -p $pw ssh $host "mkdir -p /home/pi/n8n"
    sshpass -p $pw ssh $host "mkdir -p /home/pi/n8n-files"
    sshpass -p $pw ssh $host "sudo chown -R 1000:1000 /home/pi/n8n"
    sshpass -p $pw ssh $host "sudo chown -R 1000:1000 /home/pi/n8n-files"
    sshpass -p $pw ssh $host  $"sudo docker compose --env-file homelab.env --file /home/pi/homelab.yml up --force-recreate -d"
  }
}
