def should_have_email_tag(name)
  expect(response.body).to have_css("input[type=\"email\"][name=\"#{name}\"]")
end

def should_have_password_tag(name)
  expect(response.body).to have_css("input[type=\"password\"][name=\"#{name}\"]")
end

def should_have_submit_button_tag(name)
  expect(response.body).to have_css("button[type=\"submit\"]", text: name)
end