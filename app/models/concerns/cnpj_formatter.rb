 module CNPJFormatter
   def cnpj_root_format(cnpj)
     CNPJ.new(cnpj).stripped[0..8]
   end
 end
