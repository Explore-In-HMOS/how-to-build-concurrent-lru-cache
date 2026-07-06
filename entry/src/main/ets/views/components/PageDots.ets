@ComponentV2
export struct PageDots {
  @Param @Require total: number = 1;
  @Param @Require current: number = 0;

  build() {
    Row({ space: 6 }) {
      ForEach(Array.from({ length: this.total }, (_: object, i: number) => i), (i: number) => {
        Circle()
          .width(i === this.current ? 7 : 5)
          .height(i === this.current ? 7 : 5)
          .fill(i === this.current ? '#E5E5E5' : '#333333')
      }, (i: number) => i.toString())
    }
  }
}