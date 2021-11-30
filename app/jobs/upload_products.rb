class UploadProducts
  
    attr_accessor :products,:user,:order
  
    def self.save_product(products,user,order)
      rp = self.new
      rp.products = products
      rp.order = order
      rp.user = user
      rp.create
    end
  
    def create
      self.order.total = self.products.count
      self.products.each do |p|
        product = self.order.products.create({name: p[:name], description: p[:description], user: self.user})
        if product.valid?
          p[:variants].each do |v|
            product.variants.create({name: v[:name], price: v[:price]})
          end
          self.order.correct = self.order.correct + 1 
        else
          self.order.incorrect = self.order.incorrect + 1 
        end
        self.order.status = 1
        self.order.save
      end
    end
  
    
  end