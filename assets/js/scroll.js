export default ScrollDown = {
    mounted() {
      console.log("scrolling down mounted")
      this.el.scrollTop = this.el.scrollHeight
    },
  
    updated() {
        this.el.scrollTop = this.el.scrollHeight
    }
  }