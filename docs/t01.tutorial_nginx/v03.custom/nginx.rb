# File: nginx.rb (Tests específicos de Nginx)

group "Comprobar el servicio web Nginx" do
  readme "* Necesitamos un SO GNU/Linux basado en systemd. Por ejemplo: OpenSUSE, Debian, etc."

  target "Comprobar el estado del servicio Nginx"
  run "systemctl status nginx", on: :webserver
  expect "Active: active (running)"

  target "Comprobar que index.html contiene el texto 'Hola NOMBREALUMNO!'"
  readme "Se asume que Nginx está instalado en su ruta por defecto."
  run "cat /var/www/html/index.html", on: :webserver
  expect "Hola #{get(:tt_members)}!"
end

group "Comprobar Nginx desde el exterior" do 
  readme "El servicio web Nginx debe estar accesible desde el exterior."
  readme "Comprobar el puerto y la configuración del cortafuegos."

  target "Comprobar que index.html contiene el texto 'Hola NOMBREALUMNO!'"
  run "curl http://#{get(:webserver_ip)}"
  expect "Hola #{get(:tt_members)}!"
end
