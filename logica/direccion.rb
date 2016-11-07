#
# Direccion:
# Son las variables de posicion del objeto
#

class Direccion
  #
  # Constructor:
  # Inicializar todos los componentes y valores iniciales de la direccion
  # tamx = valor maximo de ancho para moverse
  # tamy = valor maximo de alto para moverse
  # movimientos = numero de veces que se mueve el objeto antes de cambiar la direccion
  # imagenx = tamaño horizontal de la imagen en pixeles
  # imageny = tamaño vertical de la imagen en pixeles
  #
  def initialize(tamx = 800, tamy = 800, movimientos = 5, imagenx = 100, imageny = 65)
    @maxx = tamx
    @maxy = tamy
    @posx = rand(@maxx)
    @posy = rand(@maxy)
    @dir = rand(16)
    @contador = 0
    @velocidad = 0.5
    @movimientos = movimientos
    @desbordamientox = imagenx / 2
    @desbordamientoy = imageny / 2
    print "Se ha seleccionado la direccion en: " + @dir.to_s + "\n"
  end #def

  #
  # obtener x:
  # Devuelve el valor de x
  #
  def get_x
    return @posx
  end #def

  #
  # obtener y:
  # Devuelve el valor de y
  #
  def get_y
    return @posy
  end #def

  #
  # mover:
  # Se mueve dependiendo del tipo de direccion
  #
  def mover
    # Si se ha movido una cantidad de veces, cambiar su direccion
    # O en caso de que se salga del margen
    if @contador > @movimientos || (@posx - @desbordamientox) < 0 || (@posy - @desbordamientoy) < 0 || (@posx + @desbordamientox) > @maxx || (@posy + @desbordamientoy) > @maxy
      self.cambiar_direccion
      @contador = 0
      print "Se ha cambiado la direccion en: " + @dir.to_s + "\n"
    end #if
    case @dir
    when 0; @posx -= @velocidad
    when 1; @posy -= @velocidad
    when 2; @posx += @velocidad
    when 3; @posy += @velocidad
    when 4; @posx -= @velocidad; @posy -= @velocidad
    when 5; @posx += @velocidad; @posy -= @velocidad
    when 6; @posx += @velocidad; @posy += @velocidad
    when 7; @posx -= @velocidad; @posy += @velocidad
    when 8; @posx -= @velocidad * 2; @posy -= @velocidad
    when 9; @posx -= @velocidad; @posy -= @velocidad * 2
    when 10; @posx += @velocidad * 2; @posy -= @velocidad
    when 11; @posx += @velocidad; @posy -= @velocidad * 2
    when 12; @posx += @velocidad; @posy += @velocidad * 2
    when 13; @posx += @velocidad * 2; @posy += @velocidad
    when 14; @posx -= @velocidad; @posy += @velocidad * 2
    when 15; @posx -= @velocidad * 2; @posy += @velocidad
    end #case
    @contador += 1
  end #def

  #
  # CambiarDireccion
  # Selecciona aleatoriamente entre las siguientes rutas
  # 0 - izq
  # 1 - arriba
  # 2 - derecha
  # 3 - abajo
  # 4 - diagonal izq-arriba
  # 5 - diagonal der-arriba
  # 6 - diagonal abajo-der
  # 7 - diagonal abajo-izq
  # 8 - diagonal izq*2-arriba
  # 9 - diagonal izq-arriba*2
  # 10 - diagonal der*2-arriba
  # 11 - diagonal der-arriba*2
  # 12 - diagonal abajo*2-der
  # 13 - diagonal abajo-der*2
  # 14 - diagonal abajo*2-izq
  # 15 - diagonal abajo-izq*2
  #
  def cambiar_direccion
    @dir = rand(16)
    @movimientos = rand(200)
    #nuevo = rand(8)
    #if nuevo == @dir
    #  self.cambiar_direccion
    #else
    #  @dir = nuevo
    #end #ifelse
  end #def

end #class
