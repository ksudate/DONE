import React from "react"

class CreateSplint extends React.Component {
  constructor(props)
  {
    super(props);
    this.state = {
      value : 1
    }
    this.fetchSplint = this.fetchSplint.bind(this)
  }

  fetchSplint = (e, splint, value) => {
    var elem = document.getElementById('test');

    var hidden_box = document.createElement('div');
    hidden_box.classList.add("hidden_box");
    elem.appendChild(hidden_box);

    var splint_number = document.createElement('label');
    splint_number.innerHTML = 'Splint' + String(value);
    hidden_box.appendChild(splint_number);

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
  }

  render () {
    return (
      <React.Fragment>
        {this.state.value}
        <button onClick={e => this.fetchSplint(e, this.props.splint, this.state.value)}>Add Splint</button>
      </React.Fragment>
    );
  }
}

export default CreateSplint