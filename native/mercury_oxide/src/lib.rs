use liquid::partials::{InMemorySource, LazyCompiler};
use liquid::model::Value;
use rustler::{Encoder, Env, Error, Term};
use serde_rustler::from_term;

mod atoms {
    rustler::atoms! {
        ok,
        error
        //atom __true__ = "true";
        //atom __false__ = "false";
    }
}


#[rustler::nif]
fn render<'a>(env: Env<'a>, template: String, var_list: Term<'a>, partials: Option<Term<'a>>) -> Result<Term<'a>, Error> {
    let var_list: Vec<(String, Value)> = from_term(var_list)?;
    let partials: Vec<(String, String)> = partials.unwrap_or(Term::list_new_empty(env)).decode()?;

    let mut partial_store = InMemorySource::new();
    for (name, partial) in partials.iter() {
        partial_store.add(name, partial);
    }

    let template = match liquid::ParserBuilder::with_stdlib()
        .partials(LazyCompiler::new(partial_store))
        .build()
        .unwrap()
        .parse(&template)
    {
        Ok(x) => x,
        Err(_e) => return Err(Error::Atom("invalid_template")),
    };

    let mut globals = liquid::Object::new();
    for (k, v) in var_list {
        globals.insert(k.into(), v);
    }

    let output = match template.render(&globals) {
        Ok(x) => x,
        Err(_e) => return Err(Error::Atom("render_error")),
    };
    Ok((atoms::ok(), (output)).encode(env))
}


rustler::init! {
    "Elixir.MercuryOxide.Native", [ render ]
}
