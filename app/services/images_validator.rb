require "google/cloud/vision"

class ImagesValidator
  FRONT_SIDE_TO_COMPARE = [
    'REPUBLICA DE COLOMBIA',
    'IDENTIFICACION PERSONAL',
    'CEDULA DE CIUDADANIA',
    'REPUBLICA DE COLOMBIA',
    'APELLIDOS',
    'NOMBRES'
  ]

  BACK_SIDE_TO_COMPARE = [
    'FECHA DE NACIMIENTO',
    'LUGAR DE NACIMIENTO',
    'ESTATURA',
    'G.S. RH',
    'SEXO',
    'FECHA Y LUGAR DE EXPEDICION',
    'REGISTRADOR NACIONAL'
  ]

  DESCRIPTIONS_TO_COMPARE = [
    'celebrity',
    'supermodel',
    'actor',
    'model',
    'football',
    'Image',
    'candidate',
    'politician',
    'singer',
    'athelete'
  ]

  def initialize
    @vision ||= Google::Cloud::Vision.new project: ENV['GOOGLE_CLOUD_NAME'], keyfile: ENV['GOOGLE_CLOUD_PROJECT']
  end

  def valid_document? document_front_side:, document_back_side:
    front_image = @vision.image document_front_side
    front_text = front_image.text
    front_side_texts = front_text.to_s.split("\n")

    back_image = @vision.image document_back_side
    back_text = back_image.text
    back_side_texts = back_text.to_s.split("\n")

    intersection_front = front_side_texts & FRONT_SIDE_TO_COMPARE
    return { valid?: false } if intersection_front.size < 4

    intersection_back = back_side_texts & BACK_SIDE_TO_COMPARE
    return { valid?: false } if intersection_back.size < 4

    number = front_side_texts[3].split(' ').last
    surnames = front_side_texts[4]
    names = front_side_texts[6]

    { valid?: true, data: { names: names, surnames: surnames, number: number } }
  end

  def wecognized_face? selfie:
    image = @vision.image selfie
    web = image.web
    descriptions = web.entities.map { |ent| ent.description.downcase }
    intersection_description = descriptions & DESCRIPTIONS_TO_COMPARE

    return { valid?: true, data: descriptions } if intersection_description.size >= 1

    { valid?: false }
  end
end
