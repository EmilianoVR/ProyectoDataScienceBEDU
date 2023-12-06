dict_gas <- list(
  PM2.5 = list(
    nombre = "Partículas en suspensión de menos de 2.5 micrómetros",
    info = "Las partículas en suspensión de menos de 2.5 micrómetros, conocidas como PM2.5, son pequeñas partículas sólidas o líquidas en el aire que pueden permanecer suspendidas durante períodos prolongados. Estas partículas pueden provenir de diversas fuentes, como la quema de combustibles fósiles, la agricultura, la construcción y otros procesos industriales. Las PM2.5 pueden penetrar profundamente en los pulmones y están asociadas con problemas respiratorios y cardiovasculares, así como con otros impactos en la salud.",
    concent = 100,  # Estimación aproximada en µg/m³ (máximo registrado)
    medida = "µg/m³"
  ),
  PM10 = list(
    nombre = "Partículas en suspensión de menos de 10 micrómetros",
    info = "Las partículas en suspensión de menos de 10 micrómetros, conocidas como PM10, son partículas más grandes que las PM2.5 pero aún lo suficientemente pequeñas como para permanecer en el aire. Estas partículas también pueden tener diversas fuentes, incluyendo la combustión de combustibles, la actividad industrial y la erosión del suelo. Las PM10 pueden afectar la salud respiratoria y también contribuir a la contaminación atmosférica.",
    concent = 150,  # Estimación aproximada en µg/m³ (máximo registrado)
    medida = "µg/m³"
  ),
  NOx = list(
    nombre = "Óxidos de Nitrógeno",
    info = "Los óxidos de nitrógeno (NOx) son una familia de gases formados por la combinación de oxígeno y nitrógeno. Incluyen óxido nítrico (NO) y dióxido de nitrógeno (NO2). Estos gases son emitidos principalmente durante la combustión de combustibles fósiles y contribuyen a la formación de la contaminación del aire. Los NOx pueden tener impactos negativos en la salud humana y también contribuir al smog y la lluvia ácida.",
    concent = 0.2,  # Estimación aproximada en ppm (máximo registrado)
    medida = "ppm"
  ),
  O3 = list(
    nombre = "Ozono",
    info = "El ozono (O3) es un gas compuesto por tres átomos de oxígeno. A nivel del suelo, el ozono es un contaminante atmosférico que puede tener efectos adversos en la salud humana y el medio ambiente. Aunque la capa de ozono en la estratosfera es beneficiosa ya que protege de la radiación ultravioleta, el ozono a nivel del suelo puede causar problemas respiratorios y otros impactos en la salud.",
    concent = 0.2,  # Estimación aproximada en ppm (máximo registrado)
    medida = "ppm"
  ),
  CO = list(
    nombre = "Monóxido de Carbono",
    info = "El monóxido de carbono (CO) es un gas incoloro e inodoro producido durante la combustión incompleta de combustibles orgánicos. Las fuentes comunes incluyen vehículos con motores de combustión interna, estufas y calentadores. El CO puede ser peligroso en espacios cerrados y puede afectar la capacidad del cuerpo para transportar oxígeno.",
    concent = 50,  # Estimación aproximada en ppm (máximo registrado)
    medida = "ppm"
  ),
  HR = list(
    nombre = "Humedad Relativa",
    info = "La Humedad Relativa (HR) es la cantidad de vapor de agua presente en el aire en relación con la cantidad máxima que podría contener a una temperatura determinada. Se expresa como un porcentaje. La HR alta indica que el aire está cerca de saturarse con vapor de agua.",
    concent = 86,  # Estimación aproximada en %
    medida = "%"
  ),
  NO = list(
    nombre = "Bioxido de Nitrogeno",
    info = "Es un gas incoloro e inodoro que se produce durante la combustión de combustibles fósiles, como el petróleo y el gas natural, y también por procesos naturales como la actividad bacteriana en el suelo. El NO es un precursor del dióxido de nitrógeno (NO2), que es un gas marrón rojizo con un olor fuerte y desagradable. Ambos son contaminantes atmosféricos que pueden tener efectos adversos en la salud humana y el medio ambiente. El NO y el NO2 pueden causar problemas respiratorios, como asma, bronquitis y enfisema, y pueden aumentar el riesgo de enfermedades cardíacas y accidentes cerebrovasculares. Además, estos gases pueden contribuir a la formación de smog y lluvia ácida, lo que puede dañar los cultivos y los bosques, y acidificar los cuerpos de agua.",
    concent = 0.210,
    medida = "ppm"
  ),
  NO2 = list(
    nombre = "Dióxido de Nitrógeno",
    info = "El dióxido de nitrógeno (NO2) es un gas marrón rojizo con un olor fuerte y desagradable. Se forma a partir de la oxidación del óxido nítrico (NO) en la atmósfera. El NO2 es un contaminante atmosférico asociado principalmente con la combustión de combustibles fósiles y puede tener efectos adversos en la salud humana, incluidos problemas respiratorios y cardiovasculares.",
    concent = 0.3,  # Estimación aproximada en ppm (máximo registrado)
    medida = "ppm"
  ),
  TMP = list(
    nombre = "Temperatura",
    info = "La Temperatura (TMP) es una medida de la energía cinética promedio de las partículas en un sistema. En este contexto, se refiere a la temperatura del aire. Se mide en grados Celsius.",
    concent = 34,  # Estimación aproximada en °C
    medida = "°C"
  )
)
