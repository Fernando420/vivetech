class UploadVariants
  
  attr_accessor :product ,:variants

  def self.save_variants(product,variants)
    rp = self.new
    rp.product = product
    rp.variants = variants
    rp.create
  end

  def create
    self.product.total = self.variants.count
    variants.each do |variant|
      sv = self.product.variants.create({name: variant[:name], price: variant[:price]})
      if sv.valid?
        self.product.correct = self.product.correct + 1 
      else
        self.product.incorrect = self.product.incorrect + 1 
      end
    end
    self.product.status = 1
    self.product.save
  end

  
end