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
    #print "Se crea un pez\n"
    @image = Image["pez3.png"]
    # Hacer que el pez se mueva
    @animation = Chingu::Animation.new(:file => "pezcompleto_50x33.bmp")
    @animation.frame_names = { :izquierda => 0...2, :derecha => 2...4 }
    @frame_name = :izquierda

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
    @reproducir = 2         # tiempo que espera para reproducirse
    @reproducir_veces1 = 0  # veces que se ha reproducido
    @reproducir_veces2 = 5  # maximo de veces que puede reproducirse
    @reproducir_puede = false
    @reproducir_inicio = Time.now
    @reproducir_desviacion = rand(5)
    @libre = true # Es para saber si el pez se puede mover hacia otra comida
    @perseguido = false # Es para saber si el pez debe evitar una coordenada
    @evitarx = 0 # Coordenadas a evitar si es perseguido
    @evitary = 0 # Coordenadas a evitar si es perseguido

  end # def

  #
  # Rango:
  # Devuelve verdadero si se encuentra en el rango de la imagen
  # int x: posicion x a mirar en el rango
  # int y: posicion y a mirar en el rango
  #
  def rango?(x, y)
    izq = @x - (@image.width / 2) + 5
    der = @x + (@image.width / 2) - 5
    arriba = @y - (@image.height / 2) + 5
    abajo = @y + (@image.height / 2) - 5

    return x > izq && x < der && y > arriba && y < abajo
  end # def

  #
  # Mover:
  # Traza una ruta al azar en la ventana
  #
  def mover
    if !@libre && !self.rango?(@buscarx, @buscary)
      @direccion.buscar(@buscarx, @buscary)

      # Si el pez esta siendo perseguido y va en una direccion que debe evitar
      # ... entonces queda libre para buscar otra ruta
      if @direccion.evitar?(@evitarx, @evitary)
        @libre = true
      end # if

    elsif @libre
      # Si el pez esta siendo perseguido y va en una direccion que debe evitar
      # ... entonces queda libre para buscar otra ruta
      if @direccion.evitar?(@evitarx, @evitary)
        @direccion.cambiar_direccion
      end # if
      @direccion.mover
    else
      @libre = true
    end # if
    @x = @direccion.get_x
    @y = @direccion.get_y
    #print "cords (" + @direccion.get_x.to_s + "," + @direccion.get_y.to_s + ")\n"
  end # def

  #
  # Definir Parametros:
  #   Configura todas las opciones del pez
  # int genero: Es el genero que tendra el pez (1 = hembra, 2 = macho)
  # int vida_tiempo: Es el número de segundos que vive
  # int reproducir_veces: Es el numero máximo de veces que se puede reproducir
  # int reproducir_tiempo: Es el tiempo que espera antes de reproducirse de nuevo
  #
  def definir_parametros(genero, vida_tiempo, reproducir_veces, reproducir_tiempo)
    @genero = genero
    if @genero == 1
      @animation = Chingu::Animation.new(:file => "pezcompletoh_50x33.bmp")
    else
      @animation = Chingu::Animation.new(:file => "pezcompletom_50x33.bmp")
    end # if
    @animation.frame_names = { :izquierda => 0...2, :derecha => 2...4 }
    @vida = vida_tiempo
    @reproducir_veces2 = reproducir_veces
    @reproducir = reproducir_tiempo
  end #def

  #
  # Definir Posicion:
  # La ubicacion del pez queda en la especificada
  #
  def definir_parametros2(x, y, genero, vida_tiempo, reproducir_veces, reproducir_tiempo)
    definir_parametros(genero, vida_tiempo, reproducir_veces, reproducir_tiempo)
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

    @image = @animation[@frame_name].next
    @frame_name = @direccion.izquierda? ? :izquierda : :derecha

    self.mover
    # if @genero == 1
    #   @color = Color::FUCHSIA
    # else
    #   @color = Color::GREEN
    # end # if

    # El pez muere luego de que pasa el tiempo de vida + desviacion
    if (Time.now - @vida_inicio) > @vida + @vida_desviacion
      print "Muere el pez '#{@nombre}', vivió #{(Time.now - @vida_inicio).to_i} segundos...\n" if $modo_debug
      @pez_vivo = false
      @image = Image["pezd.png"]
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
  #   Se llama cuando el pez se encuentra con otro pez
  #   El pez sólo colisiona con un pez diferente cada vez
  #
  def colision_pez(pez)
    if @ultimo != pez.get_nombre
      @ultimo = pez.get_nombre
      @color = Color::BLUE
      print rand(10).to_s + " Colision..." + @nombre + "\n" if $modo_debug

    end # if
  end # def

  #
  # Comer:
  #   Cuando un pez come se hace mas grande, cambia la imagen
  #
  def comer
    # @image = Image["pez2.png"]
    # Al comer, un pez tendrá x segundos mas de vida, y queda libre para buscar mas comida
    @vida_inicio += 2
    @libre = true
  end # def

  #
  # Buscar:
  #   Un pez puede ir a buscar una comida
  # int x: posicion x a ir a buscar
  # int y: posicion y a ir a buscar
  #
  def buscar(x, y)
    @buscarx = x
    @buscary = y
    @libre = false
  end # def

  #
  # Evitar:
  #   Un pez debe evitar ser comida de tiburon
  # int x: posicion x a ir a evitar
  # int y: posicion y a ir a evitar
  #
  def evitar(x, y)
    @evitarx = x
    @evitary = y
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
  def get_libre; @libre; end
  def get_x; @x; end
  def get_y; @y; end



end #class
