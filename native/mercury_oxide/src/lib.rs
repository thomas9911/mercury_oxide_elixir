#[macro_use]
extern crate rustler;
extern crate liquid;

use liquid::partials::{InMemorySource, LazyCompiler};
use liquid::value::Value;
use rustler::{Encoder, Env, Error, Term};
use serde_rustler::from_term;

mod atoms {
    rustler_atoms! {
        atom ok;
        atom error;
        //atom __true__ = "true";
        //atom __false__ = "false";
    }
}

rustler::rustler_export_nifs! {
    "Elixir.MercuryOxide.Native",
    [
        ("render", 2, render),
        ("render", 3, render),
    ],
    None
}

fn render<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    let template: String = args[0].decode()?;
    let var_list: Vec<(String, Value)> = from_term(args[1])?;
    let partials: Vec<(String, String)> =
        args.get(2).unwrap_or(&Term::list_new_empty(env)).decode()?;

    let mut partial_store = InMemorySource::new();
    for (name, partial) in partials.iter() {
        partial_store.add(name, partial);
    }

    let template = match liquid::ParserBuilder::with_liquid()
        .partials(LazyCompiler::new(partial_store))
        .build()
        .unwrap()
        .parse(&template)
    {
        Ok(x) => x,
        Err(_e) => return Err(Error::Atom("invalid_template")),
    };

    let mut globals = liquid::value::Object::new();
    for (k, v) in var_list {
        globals.insert(k.into(), v);
    }

    let output = match template.render(&globals) {
        Ok(x) => x,
        Err(_e) => return Err(Error::Atom("render_error")),
    };
    Ok((atoms::ok(), (output)).encode(env))
}
