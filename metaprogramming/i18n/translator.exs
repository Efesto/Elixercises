defmodule Translator do
  defmacro __using__(_opts) do
    quote do
      # registers an accumulated @locales attribute
      Module.register_attribute(__MODULE__, :locales, accumulate: true, persist: false)

      import unquote(__MODULE__), only: [locale: 2]
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(env) do
    compile(Module.get_attribute(env.module, :locales))
  end

  defmacro locale(name, mappings) do
    quote bind_quoted: [name: name, mappings: mappings] do
      @locales {name, mappings}
    end
  end

  def compile(translations) do
    # returns AST of translation function definition
    translations_ast =
      for {locale, mappings} <- translations do
        deftranslations(locale, "", mappings)
      end

    final_ast =
      quote do
        def t(locale, path, bindings \\ [])
        unquote(translations_ast)

        def t(_locale, _path, _bindings), do: {:error, :no_translation}
      end

    # prints generated AST
    # IO.puts(Macro.to_string(final_ast))
    final_ast
  end

  defp deftranslations(locale, current_path, mappings) do
    # returns AST of t/3 functions for given locale
    for {key, val} <- mappings do
      path = append_path(current_path, key)

      if Keyword.keyword?(val) do
        deftranslations(locale, path, val)
      else
        case val do
          [string, :singular] ->
            quote do
              def t(unquote(locale), unquote(path), bindings = %{count: 1}) do
                unquote(interpolate(string))
              end
            end

          [string, :plural] ->
            quote do
              def t(unquote(locale), unquote(path), bindings = %{count: count})
                  when (is_integer(count) and count > 1) or count <= 0 do
                unquote(interpolate(string))
              end
            end

          _ ->
            quote do
              def t(unquote(locale), unquote(path), bindings) do
                unquote(interpolate(val))
              end
            end
        end
      end
    end
  end

  defp append_path("", next), do: to_string(next)
  defp append_path(current, next), do: "#{current}.#{next}"

  defp interpolate(string) do
    ~r/(?<head>)%{[^}]+}(?<tail>)/
    |> Regex.split(string, on: [:head, :tail])
    |> Enum.reduce("", fn
      <<"%{" <> rest>>, acc ->
        key = String.to_atom(String.trim_trailing(rest, "}"))

        quote do
          # This ast is included directly in the function body so we can access bindings directly as they share the same context
          unquote(acc) <> to_string(Map.fetch!(bindings, unquote(key)))
        end

      segment, acc ->
        quote do: unquote(acc) <> unquote(segment)
    end)
  end
end
