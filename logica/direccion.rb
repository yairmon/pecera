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
    @dir = rand(16)
    @contador = 0
    @velocidad_inicial = 0.5
    @velocidad = @velocidad_inicial
    @velocidad_alta = 2.5
    @movimientos = movimientos
    @desbordamientox = imagenx / 2
    @desbordamientoy = imageny / 2
    @posx = @desbordamientox + rand(@maxx - @desbordamientox * 2)
    @posy = @desbordamientoy + rand(@maxy - @desbordamientoy * 2)
    #print "Se ha seleccionado la direccion en: " + @dir.to_s + "\n"
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
      #print "Se ha cambiado la direccion en: " + @dir.to_s + "\n"
    end #if

    self.cambiar_posicion

    @contador += 1
  end #def

  #
  # Cambiar Posicion
  # Dependiendo de la direccion suma o resta las variables X y Y
  #
  def cambiar_posicion
    case @dir
    when 0; @posx -= @velocidad
    when 1; @posy -= @velocidad
    when 2; @posx += @velocidad
    when 3; @posy += @velocidad
    when 4; @posx -= @velocidad; @posy -= @velocidad
    when 5; @posx += @velocidad; @posy -= @velocidad
    when 6; @posx += @velocidad; @posy += @velocidad
    when 7; @posx -= @velocidad; @posy += @velocidad
    when 8; @posx -= @velocidad * 1.2; @posy -= @velocidad
    when 9; @posx -= @velocidad; @posy -= @velocidad * 1.2
    when 10; @posx += @velocidad * 1.2; @posy -= @velocidad
    when 11; @posx += @velocidad; @posy -= @velocidad * 1.2
    when 12; @posx += @velocidad; @posy += @velocidad * 1.2
    when 13; @posx += @velocidad * 1.2; @posy += @velocidad
    when 14; @posx -= @velocidad; @posy += @velocidad * 1.2
    when 15; @posx -= @velocidad * 1.2; @posy += @velocidad
    end #case
  end # def

  #
  # Buscar:
  # Selecciona una ruta para llegar a las coordenadas seleccionadas
  # int x: posicion x a ir a buscar
  # int y: posicion y a ir a buscar
  #
  def buscar(x, y)
    if @posx > x && @posy == y; @dir = 0
    elsif @posx == x && @posy > y; @dir = 1
    elsif @posx < x && @posy == y; @dir = 2
    elsif @posx == x && @posy < y; @dir = 3
    elsif @posx > x && @posy > y; @dir = 4
    elsif @posx < x && @posy > y; @dir = 5
    elsif @posx < x && @posy < y; @dir = 6
    elsif @posx > x && @posy < y; @dir = 7
    else; @dir = rand(16)
    end # if

    self.cambiar_posicion
  end # def

  #
  # Evitar:
  # Dice si la ruta que lleva está en la ruta a evitar
  # int x: posicion x a evitar
  # int y: posicion y a evitar
  #
  def evitar?(x, y)
    if @posx < x && @posy == y; salida = @dir==0||@dir==4||@dir==7||@dir==8||@dir==9||@dir==14||@dir==15
    elsif @posx == x && @posy < y; salida = @dir==1||@dir==4||@dir==5||@dir==8||@dir==9||@dir==10||@dir==11
    elsif @posx > x && @posy == y; salida = @dir==2||@dir==5||@dir==6||@dir==10||@dir==11||@dir==12||@dir==13
    elsif @posx == x && @posy > y; salida = @dir==3||@dir==6||@dir==7||@dir==12||@dir==13||@dir==14||@dir==15
    elsif @posx < x && @posy < y; salida = @dir==4||@dir==0||@dir==7||@dir==8||@dir==9||@dir==14||@dir==15||@dir==1||@dir==5||@dir==10||@dir==11
    elsif @posx > x && @posy < y; salida = @dir==5||@dir==2||@dir==6||@dir==10||@dir==11||@dir==12||@dir==13||@dir==1||@dir==4||@dir==8||@dir==9
    elsif @posx > x && @posy > y; salida = @dir==6||@dir==3||@dir==7||@dir==12||@dir==13||@dir==14||@dir==15||@dir==2||@dir==5||@dir==10||@dir==11
    elsif @posx < x && @posy > y; salida = @dir==7||@dir==3||@dir==6||@dir==12||@dir==13||@dir==14||@dir==15||@dir==0||@dir==4||@dir==8||@dir==9
    end # if

    return !salida

  end # def

  #
  # Cambiar Direccion
  # Selecciona aleatoriamente entre las siguientes rutas
  # 0 - izq
  # 1 - arriba
  # 2 - derecha
  # 3 - abajo
  # 4 - diagonal izq-arriba
  # 5 - diagonal der-arriba
  # 6 - diagonal abajo-der
  # 7 - diagonal abajo-izq
  # 8 - diagonal izq*1.2-arriba
  # 9 - diagonal izq-arriba*1.2
  # 10 - diagonal der*1.2-arriba
  # 11 - diagonal der-arriba*1.2
  # 12 - diagonal abajo*1.2-der
  # 13 - diagonal abajo-der*1.2
  # 14 - diagonal abajo*1.2-izq
  # 15 - diagonal abajo-izq*1.2
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

  #
  # Aumentar Velocidad:
  # Es para multiplicar la velocidad de movimiento dos veces
  #
  def aumentar_velocidad
    @velocidad = @velocidad_alta
  end # def

  #
  # Disminuir Velocidad:
  # Es para dividir la velocidad de movimiento dos veces
  #
  def disminuir_velocidad
    @velocidad = @velocidad_inicial
  end # def

  #
  # Izquierda?:
  # Dice la direccion es la izquierda (Esto para las animaciones)
  #
  def izquierda?
    if @dir == 0 || @dir == 4 || @dir == 7 || @dir == 8 || @dir == 9 || @dir == 14 || @dir == 15
      return true
    # elsif @dir == 2 || @dir == 5 || @dir == 6 || @dir == 10 || @dir == 11 || @dir == 12 || @dir == 13
    #   return false
    else
      return false
    end # if
  end # def


  # _______________________________
  #        GETTERS & SETTERS
  # _______________________________
  def get_dir; @dir; end
  def get_x; @posx; end
  def set_x(x) @posx = x; end
  def get_y; @posy; end
  def set_y(y) @posy = y; end


end #class
