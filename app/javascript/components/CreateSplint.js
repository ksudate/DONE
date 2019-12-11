import React from "react"

class CreateSplint extends React.Component {
  constructor(props)
  {
    super(props);
    this.state = {
      value : 1
    }
    this.fetchSplint = this.fetchSplint.bind(this)
    var cookies = document.cookie
    var j = 1;
    if (document.cookie) {
      var cookieArray = cookies.split('=');
      var count =　parseInt(cookieArray[1]);
      var splint = this.props.splint;
      while (count >= j) {
        var elem = document.getElementById('test');
        var hidden_box = document.createElement('div');
        hidden_box.classList.add("hidden_box");
        elem.appendChild(hidden_box);

        var splint_number = document.createElement('label');
        splint_number.innerHTML = 'Sprint' + String(j);
        hidden_box.appendChild(splint_number);

        var delete_splint = document.createElement("form");
        delete_splint.action = "/splints/delete_splint?sp_number=" + String(j);
        delete_splint.method = "POST";
        hidden_box.appendChild(delete_splint);

        var delete_hidden = document.createElement("input");
        var delete_submit = document.createElement("input");
        delete_hidden.setAttribute("type", "hidden");
        delete_submit.setAttribute("type", "submit");
        delete_hidden.setAttribute("name", "_method");
        delete_hidden.setAttribute("value", "DELETE");
        delete_submit.setAttribute("value", "DELETE Sprint");
        delete_submit.classList.add("delete-link");
        delete_splint.appendChild(delete_hidden);
        delete_splint.appendChild(delete_submit);

        var kpt_table = document.createElement('div');
        var div_keep = document.createElement('div');
        var div_problem = document.createElement('div');
        var div_try = document.createElement('div');
        kpt_table.id = 'kpt-table';
        var table_keep = document.createElement('table');
        var table_problem = document.createElement('table');
        var table_try = document.createElement('table');
        hidden_box.appendChild(kpt_table);
        kpt_table.appendChild(div_keep);
        kpt_table.appendChild(div_problem);
        kpt_table.appendChild(div_try);
        div_keep.appendChild(table_keep);
        div_problem.appendChild(table_problem);
        div_try.appendChild(table_try);

        var tr_keep = document.createElement('tr');
        var tr_problem = document.createElement('tr');
        var tr_try = document.createElement('tr');
        table_keep.appendChild(tr_keep);
        table_problem.appendChild(tr_problem);
        table_try.appendChild(tr_try);

        var th_keep = document.createElement('th');
        var th_problem = document.createElement('th');
        var th_try = document.createElement('th');
        th_keep.innerHTML = 'Keep';
        th_problem.innerHTML = 'Problem';
        th_try.innerHTML = 'Try';
        tr_keep.appendChild(th_keep);
        tr_problem.appendChild(th_problem);
        tr_try.appendChild(th_try);

        var obj = JSON.parse(splint);
        for(let i = 0; i < obj.length; i++) {
          if (obj[i].sp_number == j ) {
            var tr = document.createElement('tr');
            var td = document.createElement('td');
            var a = document.createElement('a');
            var div = document.createElement('div');
            a.href = "/splints/" + obj[i].id;
            a.classList.add("splint-a");
            div.innerHTML = obj[i].content;
            a.appendChild(div);
            td.appendChild(a);
            tr.appendChild(td);
            if (obj[i].kpt == 'Keep') {
              table_keep.appendChild(tr);
            } else if (obj[i].kpt == 'Problem') {
              table_problem.appendChild(tr);
            } else if (obj[i].kpt == 'Try') {
              table_try.appendChild(tr);
            }
          }
        }

        var new_link_div = document.createElement('div');
        new_link_div.classList.add("new-link-div");
        div_keep.appendChild(new_link_div);
        var new_link = document.createElement('a');
        new_link.id = 'new-link';
        new_link.href = '/splints/new?kpt=Keep&sp_number=' + String(j);
        new_link.innerHTML = '+';
        new_link_div.appendChild(new_link);

        var new_link_div = document.createElement('div');
        new_link_div.classList.add("new-link-div");
        div_problem.appendChild(new_link_div);
        var new_link = document.createElement('a');
        new_link.id = 'new-link';
        new_link.href = '/splints/new?kpt=Problem&sp_number=' + String(j);
        new_link.innerHTML = '+';
        new_link_div.appendChild(new_link);

        var new_link_div = document.createElement('div');
        new_link_div.classList.add("new-link-div");
        div_try.appendChild(new_link_div);
        var new_link = document.createElement('a');
        new_link.id = 'new-link';
        new_link.href = '/splints/new?kpt=Try&sp_number=' + String(j);
        new_link.innerHTML = '+';
        new_link_div.appendChild(new_link);
        this.state = { value : j + 1 };
        j++
      }
    } else {
      document.cookie = "number=0"
    }
  }

  fetchSplint = (e, splint, value) => {
    var elem = document.getElementById('test');

    var hidden_box = document.createElement('div');
    hidden_box.classList.add("hidden_box");
    elem.appendChild(hidden_box);

    var splint_number = document.createElement('label');
    splint_number.innerHTML = 'Splint' + String(value);
    hidden_box.appendChild(splint_number);

    var delete_splint = document.createElement("form");
    delete_splint.action = "/splints/delete_splint?sp_number=" + String(value);
    delete_splint.method = "POST";
    hidden_box.appendChild(delete_splint);

    var delete_hidden = document.createElement("input");
    var delete_submit = document.createElement("input");
    delete_hidden.setAttribute("type", "hidden");
    delete_submit.setAttribute("type", "submit");
    delete_hidden.setAttribute("name", "_method");
    delete_hidden.setAttribute("value", "DELETE");
    delete_submit.setAttribute("value", "DELETE Sprint");
    delete_submit.classList.add("delete-link");
    delete_splint.appendChild(delete_hidden);
    delete_splint.appendChild(delete_submit);

    var kpt_table = document.createElement('div');
    var div_keep = document.createElement('div');
    var div_problem = document.createElement('div');
    var div_try = document.createElement('div');
    kpt_table.id = 'kpt-table';
    var table_keep = document.createElement('table');
    var table_problem = document.createElement('table');
    var table_try = document.createElement('table');
    hidden_box.appendChild(kpt_table);
    kpt_table.appendChild(div_keep);
    kpt_table.appendChild(div_problem);
    kpt_table.appendChild(div_try);
    div_keep.appendChild(table_keep);
    div_problem.appendChild(table_problem);
    div_try.appendChild(table_try);

    var tr_keep = document.createElement('tr');
    var tr_problem = document.createElement('tr');
    var tr_try = document.createElement('tr');
    table_keep.appendChild(tr_keep);
    table_problem.appendChild(tr_problem);
    table_try.appendChild(tr_try);

    var th_keep = document.createElement('th');
    var th_problem = document.createElement('th');
    var th_try = document.createElement('th');
    th_keep.innerHTML = 'Keep'
    th_problem.innerHTML = 'Problem'
    th_try.innerHTML = 'Try'
    tr_keep.appendChild(th_keep);
    tr_problem.appendChild(th_problem);
    tr_try.appendChild(th_try);

    var obj = JSON.parse(splint);
    for(let i = 0; i < obj.length; i++) {
      if (obj[i].sp_number == value) {
        var tr = document.createElement('tr');
        var td = document.createElement('td');
        var a = document.createElement('a');
        var div = document.createElement('div');
        a.href = "/splints/" + obj[i].id;
        a.classList.add("splint-a");
        div.innerHTML = obj[i].content;
        a.appendChild(div);
        td.appendChild(a);
        tr.appendChild(td);
        if (obj[i].kpt == 'Keep') {
          table_keep.appendChild(tr);
        } else if (obj[i].kpt == 'Problem') {
          table_problem.appendChild(tr);
        } else if (obj[i].kpt == 'Try') {
          table_try.appendChild(tr);
        }
      }
    }

    var new_link_div = document.createElement('div');
    new_link_div.classList.add("new-link-div");
    div_keep.appendChild(new_link_div);
    var new_link = document.createElement('a');
    new_link.id = 'new-link'
    new_link.href = '/splints/new?kpt=Keep&sp_number=' + String(value);
    new_link.innerHTML = '+'
    new_link_div.appendChild(new_link);

    var new_link_div = document.createElement('div');
    new_link_div.classList.add("new-link-div");
    div_problem.appendChild(new_link_div);
    var new_link = document.createElement('a');
    new_link.id = 'new-link'
    new_link.href = '/splints/new?kpt=Problem&sp_number=' + String(value);
    new_link.innerHTML = '+'
    new_link_div.appendChild(new_link);

    var new_link_div = document.createElement('div');
    new_link_div.classList.add("new-link-div");
    div_try.appendChild(new_link_div);
    var new_link = document.createElement('a');
    new_link.id = 'new-link'
    new_link.href = '/splints/new?kpt=Try&sp_number=' + String(value);
    new_link.innerHTML = '+'
    new_link_div.appendChild(new_link);
    this.setState({ value: value + 1 });

    var value_count = this.state.value
    String(value_count)
    var value_count = "number=" + value_count;
    document.cookie = value_count;
  }

  render () {
    return (
      <React.Fragment>
        <button id="add-splint" onClick={e => this.fetchSplint(e, this.props.splint, this.state.value)}>Add Sprint</button>
      </React.Fragment>
    );
  }
}

export default CreateSplint