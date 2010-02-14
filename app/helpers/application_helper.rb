module ApplicationHelper
  def do_pag(coll, remote = {})
    return [["&nbsp;".html_safe!], [will_paginate(coll, :remote => remote)]]
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

  # takes [[1,2], [1,2],...]
  def gen_list(items=[], opts={})
    head = (opts[:head] || nil)
    num = (opts[:size] || 3)
    sublist = opts[:sublist] ? true : false
    opts = (opts[:params] || [])
    (num - opts.size).times {|i| opts << '' } unless opts.size >= num
    items.count.times {|c|
      num.times {|i|
        if items[c][i] && items[c][i].class == String && items[c][i].scan("\n").length > 0
          items[c][i] = h(items[c][i]) unless items[c][i].html_safe?
          items[c][i] = items[c][i].split("\n").join("<br />").html_safe!
        end
      }
    }
    return render(:partial => 'widgets/gen_list', :locals => {:sublist => sublist, :items => items, :head => head, :num => num, :opts => opts})
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
    (p ? p : page) << "$('notice_div_id').hide(); $('error_div_id').hide();"
    (p ? p : page) << "Flash.transferFromCookies();"
    (p ? p : page) << "Flash.writeDataTo('notice', $('notice_div_id'));"
    (p ? p : page) << "Flash.writeDataTo('error', $('error_div_id'));"
    (p ? p : page) << "if ($('notice_div_id').innerHTML != '') { $('notice_div_id').show() }"
    (p ? p : page) << "if ($('error_div_id').innerHTML != '') { $('error_div_id').show() }"
  end

  def format_as_currency(value)
    return number_to_currency(value, { :unit => "£"})
  end

end
