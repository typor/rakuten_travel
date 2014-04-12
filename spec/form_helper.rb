def should_have_text_tag(name)
  should_have_input_tag('text', name: name)
end

def should_have_select_tag(name)
  expect(response.body).to have_css("select[name=\"#{name}\"]")
end

def should_have_checkbox_tag(name)
  should_have_input_tag('checkbox', name: name)
  should_have_input_tag('hidden', name: name, value: 0)
end

def should_have_email_tag(name)
  should_have_input_tag('email', name: name)
end

def should_have_number_tag(name)
  should_have_input_tag('number', name: name)
end

def should_have_password_tag(name)
  should_have_input_tag('password', name: name)
end

def should_have_submit_button_tag(name)
  expect(response.body).to have_css("button[type=\"submit\"]", text: name)
end

def should_have_submit_tag(name)
  should_have_input_tag('submit', value: name)
end

def should_have_input_tag(type, options = {})
  css = ''
  options.each_pair do |k,v|
    css << "[#{k}=\"#{v}\"]"
  end

  expect(response.body).to have_css("input[type=\"#{type}\"]" + css)
end