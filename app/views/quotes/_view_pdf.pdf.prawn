if quote.organisation.image
  img = "#{RAILS_ROOT}/public#{quote.organisation.image.public_filename}"
  pdf.image img, :at => [-30,750], :fit => [300,200]
end

pdf.text "Quotation", :align => :right, :size => 50
pdf.text quote.organisation.name, :align => :right, :size => 16
pdf.text quote.organisation.address, :align => :right, :size => 16
pdf.text " ", :align => :right, :size => 80
left = <<eof
#{quote.contact.name_long}
#{quote.contact.street}
#{quote.contact.address}
#{quote.contact.postcode}
eof
right = <<eof
Quotation date: #{quote.produced_on.inspect}
Valid until: #{quote.produced_on.inspect}
Our ref: #{quote.id}
eof
pdf.table [[{:text => left, :align => :left, :size => 14}, {:text => right, :align => :right, :size => 14}]],
  :width => 550,
  :border_width => 0

pdf.text <<eof


eof
items = []
total = 0
quote.items.each {|i|
  items << [i.desc, i.quantity, '£' + i.value.to_s]
  total = total + i.quantity * i.value
}
items << [{:text => 'Total', :colspan => 2, :align => :right}, '£' + total.to_s]
pdf.table items,
  :position => :center,
  :headers => ['Description', 'Quantity', 'Value'],
  :column_widths => {0 => 400, 1 => 70, 2 => 70},
  :border_style => :grid,
  :header_color => 'e7e7e7',
  :header_text_color => '000000',
  :row_colors => ["ffffff", "f6f6f6"]
pdf.text <<eof


eof
pdf.text "If you would like to go ahead with this quote, please contact us:", :size => 14
pdf.text "  Email: #{quote.organisation.email}" if quote.organisation.email
pdf.text "  Phone: #{quote.organisation.phone}" if quote.organisation.phone
pdf.text "  Website: #{quote.organisation.website}" if quote.organisation.website
pdf.text <<eof



eof
tmp = <<eof
All quotations are subject to change and are bound by our standard terms and conditions which are available on request.

eof
pdf.text tmp, :size => 10, :align => :center
pdf.text quote.organisation.footer, :size => 10, :align => :center

