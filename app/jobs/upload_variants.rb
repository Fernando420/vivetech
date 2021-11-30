class UploadVariants
  
  attr_accessor :product ,:variants

  def self.save_variants(product,variants)
    rp = self.new
    rp.product = product
    rp.variants = variants
    rp.create
  end

  def create
    variants.each do |variant|
      self.product.variants.create({name: variant[:name], price: variant[:price]})
    end
  end

  
end