if invoice.organisation.image
  img = "#{RAILS_ROOT}/public#{invoice.organisation.image.public_filename}"
  pdf.image img, :at => [-30,750], :fit => [300,200]
end

pdf.text "Invoice", :align => :right, :size => 50
pdf.text invoice.organisation.name.to_s, :align => :right, :size => 16
pdf.text invoice.organisation.address.to_s, :align => :right, :size => 16
pdf.text " ", :align => :right, :size => 80
left = <<eof
#{invoice.contact.name_long.to_s}
#{invoice.contact.street.to_s}
#{invoice.contact.address.to_s}
#{invoice.contact.postcode.to_s}
eof
right = <<eof
Invoice date: #{invoice.produced_on.to_s}
Payment due by: #{invoice.due_on.to_s}
Our ref: #{invoice.id}
eof
pdf.table [[{:text => left, :align => :left, :size => 14}, {:text => right, :align => :right, :size => 14}]],
  :width => 550,
  :border_width => 0

pdf.text <<eof


eof
items = []
total = 0
invoice.items.each {|i|
  items << [i.desc, i.quantity, format_as_currency(i.value)]
  if false == i.quantity.nil? && false == i.value.nil?
    total = total + i.quantity * i.value
  end
}
items << [{:text => 'Total', :colspan => 2, :align => :right}, format_as_currency(total)]
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
pdf.text "If you have any queries re this invoice, please contact us:", :size => 14
pdf.text "  Email: #{invoice.organisation.email.to_s}" if invoice.organisation.email
pdf.text "  Phone: #{invoice.organisation.phone.to_s}" if invoice.organisation.phone
pdf.text "  Website: #{invoice.organisation.website.to_s}" if invoice.organisation.website
pdf.text <<eof



eof
tmp = <<eof
All invoices are bound by our standard terms and conditions which are available on request.

eof
pdf.text tmp, :size => 10, :align => :center
pdf.text invoice.organisation.footer.to_s, :size => 10, :align => :center

