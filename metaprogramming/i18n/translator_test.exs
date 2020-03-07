ExUnit.start()
Code.require_file("translator.exs", __DIR__)

defmodule TranslatorTest do
  use ExUnit.Case

  use Translator

  locale("en",
    flash: [
      hello: "Hello %{first} %{last}!",
      bye: "Bye!"
    ],
    users: [
      title: ["Users", :plural],
      title: ["User", :singular],
      hello: ["%{attribute} people", :plural],
      hello: ["%{attribute} person", :singular]
    ]
  )

  locale("fr",
    flash: [
      hello: "Salut %{first} %{last}!",
      bye: "Au revoir!"
    ],
    users: [
      title: "Utilisateurs"
    ]
  )

  test "t/3 simple translations" do
    assert t("en", "flash.bye") == "Bye!"
    assert t("fr", "flash.bye") == "Au revoir!"
  end

  test "t/3 translations with interpolations" do
    assert t("en", "flash.hello", %{first: "mario", last: "rossi"}) == "Hello mario rossi!"
  end

  test "t/3 translations with plurals" do
    assert t("en", "users.title", %{count: 2}) == "Users"
    assert t("en", "users.title", %{count: 666}) == "Users"
    assert t("en", "users.title", %{count: 0}) == "Users"
    assert t("en", "users.title", %{count: 1}) == "User"
  end

  test "t/3 translations with plurals and interpolation" do
    assert t("en", "users.hello", %{count: 2, attribute: "Nice"}) == "Nice people"
    assert t("en", "users.hello", %{count: 1, attribute: "Nice"}) == "Nice person"
  end
end
