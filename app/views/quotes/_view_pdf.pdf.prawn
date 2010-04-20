if quote.organisation.image
  img = "#{RAILS_ROOT}/public#{quote.organisation.image.public_filename}"
  pdf.image img, :at => [-30,750], :fit => [300,200]
end

pdf.text "Quotation", :align => :right, :size => 50
pdf.text quote.organisation.name.to_s, :align => :right, :size => 16
pdf.text quote.organisation.address.to_s, :align => :right, :size => 16
pdf.text " ", :align => :right, :size => 80
left = <<eof
#{quote.contact.name_long.to_s}
#{quote.contact.street.to_s}
#{quote.contact.address.to_s}
#{quote.contact.postcode.to_s}
eof
right = <<eof
Quotation date: #{quote.produced_on.to_s}
Valid until: #{quote.produced_on.to_s}
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
  quantity = i.quantity ? i.quantity : 0.0
  value = i.value ? i.value : 0.0
  items << [i.desc, quantity, format_as_currency(value), format_as_currency(quantity * value)]
  total = total + quantity * value
}
items << [{:text => 'Total', :colspan => 3, :align => :right}, format_as_currency(total)]
pdf.table items,
  :position => :center,
  :headers => ['Description', 'Quantity', 'Value', 'Total'],
  :column_widths => {0 => 350, 1 => 55, 2 => 65, 3 => 70},
  :border_style => :grid,
  :header_color => 'e7e7e7',
  :header_text_color => '000000',
  :row_colors => ["ffffff", "f6f6f6"]
pdf.text <<eof


eof
pdf.text "If you would like to go ahead with this quote, please contact us:", :size => 14
pdf.text "  Email: #{quote.organisation.email.to_s}" if quote.organisation.email
pdf.text "  Phone: #{quote.organisation.phone.to_s}" if quote.organisation.phone
pdf.text "  Website: #{quote.organisation.website.to_s}" if quote.organisation.website
pdf.text <<eof



eof
tmp = <<eof
All quotations are subject to change and are bound by our standard terms and conditions which are available on request.

eof
pdf.text tmp, :size => 10, :align => :center
pdf.text quote.organisation.footer, :size => 10, :align => :center

