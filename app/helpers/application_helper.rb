module ApplicationHelper
  def do_pag(coll, remote = {})
    return will_paginate(coll, :remote => remote)
  end
  
  def link_to_remote(name, options = {}, html_options = nil)
    name = h(name)
    super.html_safe!
  end

  def calendar_date_select_output(input, image, options = {}, javascript_options = {})
    options[:value] = h(options[:value])
    super.html_safe!
  end

  def submit_tag(name, opts={})
    return ("<button name='commit' type='submit'>#{h name}</button>" +
          "<input type='hidden' name='commit' value='commit' />").html_safe!
  end

  def make_html_safe(inp)
    if inp.class == String && inp.html_safe? != true
      inp = h inp
    elsif inp.class == Array
      inp.size.times {|i| inp[i] = make_html_safe inp[i]}
    elsif inp.class == Hash
      inp.keys.each {|k| inp[k] = make_html_safe inp[k]}
    end
    return inp
  end

  # takes [[1,2], [1,2],...]
  def gen_list(items=[], opts={})
    opts[:size] = (opts[:size] && opts[:size].to_i > 0) ? opts[:size].to_i : 3
    opts[:size].times {|i| opts[i] = (opts[i] || "") }
    opts[:head] = opts[:head].class == Array ? opts[:head] : []
    opts[:sublist] = opts[:sublist] ? (opts[:sublist].class == String ? opts[:sublist] : "list_main_sublist") : false
    opts = make_html_safe opts
    items = make_html_safe items
    return render(:partial => 'widgets/gen_list', :locals => {:sublist => opts[:sublist], :items => items, :head => opts[:head], :num => opts[:size], :opts => opts})
  end

  def gen_items(opts={})
    return render :partial => 'widgets/gen_items', :locals => opts
  end

  # send an {} in the format {['name', {:url => {}}], [...], ....}
  def gen_dymenu(lst={})
    outp = ""
    lst.reverse.each {|i|
      outp << render(:partial => 'widgets/dymenu_item', :locals => {:name => i[0], :opts => i[1]}) 
    }
    page["dymenu"].replace_html outp
  end

  def gen_main(html="")
    page["maintext"].replace_html html
    gen_flash
  end
  
  def gen_flash(p = nil)
    # actual JS is in the layout template
    (p ? p : page) << "do_flash_message_showing();"
  end

  def format_as_currency(value)
    return number_to_currency(value, { :unit => "£"})
  end

end
