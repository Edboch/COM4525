Array.prototype.removeAt = (index) => this.splice(index, 1);

Array.prototype.remove = function(obj) {
  const index = this.indexOf(obj);
  this.splice(index, 1);
};
