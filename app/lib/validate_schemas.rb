module ValidateSchemas

  require "json-schema"

  def self.create_product(params)
    schema = File.read('./schemas/products/create.json')
    data = JSON::Validator.fully_validate(schema,params, :errors_as_objects => false)
    data = error(data) if !data.empty?
    return data
  rescue JSON::Schema::ValidationError => e
    return e
  end

  def self.error(args)
    array = []
    args.each do |t|
      t = t.split(' in schema ')[0]
      t = t.split('The property ')[1]
      array << t
    end
    return array
  end

end
