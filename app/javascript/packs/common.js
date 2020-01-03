window.switch_button_display = function switch_button_display() {
  const logout_btn = document.getElementById("logout-btn");
  if(logout_btn.style.visibility == "visible"){
    logout_btn.style.visibility = "hidden";
  }else{
    logout_btn.style.visibility = "visible";
  }
}