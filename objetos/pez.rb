#!/usr/bin/env ruby
require 'rubygems' rescue nil
$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), "..", "..", "lib")
require 'chingu'
include Gosu

require_relative "../logica/direccion"

#
# Pez:
# Es el objeto que se mueve dentro de la ventana libre y aleatoriamente
# En busca de comida y pareja
#

class Pez < Chingu::GameObject
  traits :collision_detection, :bounding_circle
  #
  # Constructor:
  # Inicializar todos los componentes y valores iniciales del pez
  #
  def initialize
    super
    @mode = :additive
    #print "Se crea un pez\n"
    @image = Image["pez3.png"]
    @direccion = Direccion.new($window.width, $window.height, 10, @image.width, @image.height)
    @pez_vivo = true
    # print @image.width.to_s + ", " + @image.height.to_s + " -- "
    # print $window.width.to_s + ", " + $window.height.to_s + "\n"
    @z = 1
    @nombre = rand.to_s
    @ultimo = self
    @genero = 1
    @vida = 5
    @vida_inicio = Time.now
    @vida_desviacion = rand(5)
    @reproducir = 2
    @reproducir_veces1 = 0 # veces que se ha reproducido
    @reproducir_veces2 = 5 # maximo de veces que puede reproducirse
    @reproducir_puede = false
    @reproducir_inicio = Time.now
    @reproducir_desviacion = rand(5)

  end # def

  #
  # Mover:
  # Traza una ruta al azar en la ventana
  #
  def mover
    @direccion.mover
    @x = @direccion.get_x
    @y = @direccion.get_y
    #print "cords (" + @direccion.get_x.to_s + "," + @direccion.get_y.to_s + ")\n"
  end # def

  #
  # Definir Parametros:
  # Configura todas las opciones del pez
  # int genero: Es el genero que tendra el pez (1 = hembra, 2 = macho)
  # int vida_tiempo: Es el número de segundos que vive
  # int reproducir_veces: Es el numero máximo de veces que se puede reproducir
  #
  def definir_parametros(genero, vida_tiempo, reproducir_veces)
    @genero = genero
    @vida = vida_tiempo
    @reproducir_veces2 = reproducir_veces
  end #def

  #
  # Definir Posicion:
  # La ubicacion del pez queda en la especificada
  #
  def definir_parametros2(x, y, genero, vida_tiempo, reproducir_veces)
    definir_parametros(genero, vida_tiempo, reproducir_veces)
    @direccion.set_x(x)
    @direccion.set_y(y)
  end # def

  #
  # Override
  # Esta funcion se ejecuta en cada frame
  # Con color blanco (WHITE) queda la imagen original
  #
  def update
    # Si el pez no esta vivo, no hacer nada en este metodo
    if !@pez_vivo; return; end

    self.mover
    if @genero == 1
      @color = Color::BLACK
    else
      @color = Color::GREEN
    end # if

    # El pez muere luego de que pasa el tiempo de vida + desviacion
    if (Time.now - @vida_inicio) > @vida + @vida_desviacion
      print "Muere el pez '#{@nombre}', vivió #{(Time.now - @vida_inicio).to_i} segundos...\n"
      @pez_vivo = false
      # self.destroy
    end # if

    # El pez puede reproducirse si se ha reproducido menos de las veces que puede
    if @reproducir_veces1 < @reproducir_veces2
      # El pez puede reproducirse cuando sobrepasa el tiempo definido + desviacion
      if (Time.now - @reproducir_inicio) > @reproducir + @reproducir_desviacion
        @reproducir_puede = true
      end # if
    end # if
  end # def

  #
  # Colision_Pez
  # Se llama cuando el pez se encuentra con otro pez
  # El pez sólo colisiona con un pez diferente cada vez
  #
  def colision_pez(pez)
    if @ultimo != pez.get_nombre
      @ultimo = pez.get_nombre
      @color = Color::BLUE
      print rand(10).to_s + " Colision..." + @nombre + "\n"

    end # if
  end # def

  #
  # Comer:
  # Cuando un pez come se hace mas grande, cambia la imagen
  #
  def comer
    @image = Image["pez2.png"]
    # Al comer, un pez tendrá x segundos mas de vida
    @vida_inicio += 2
  end # def

  #
  # Puede Reproducir:
  # Devuelve verdadero en caso de que el pez pueda reproducirse
  #
  def puede_reproducir?
    return (@reproducir_puede && @pez_vivo)
  end # def
  def reproducirse
    @reproducir_puede = false
    @reproducir_inicio = Time.now
    @reproducir_veces1 += 1
  end # def



  # _______________________________
  #        GETTERS & SETTERS
  # _______________________________
  def get_nombre; @nombre; end
  def get_genero; @genero; end
  def get_x; @x; end
  def get_y; @y; end



end #class
