

function TickTackToeController(root) {
  this.model = {
    currentPlayer: 'X',

    board: [
      [ { move: '' }, { move: '' }, { move: '' } ],
      [ { move: '' }, { move: '' }, { move: '' } ],
      [ { move: '' }, { move: '' }, { move: '' } ],
    ],

    get winner() {
      var board = this.board;
      var winner;

      function maybeThreeInARow(square) {
        if (!square.move) {
          winner = '';
          return false;
        }
        if (!winner) {
          winner = square.move;
          return true;
        }
        if (winner === square.move)
          return true;
        winner = '';
        return false;
      }

      function rowWinner(i) {
        return board[i].every(maybeThreeInARow);
      }

      function columnWinner(i) {
        return board.map(function(row) {
          return row[i]
        }).every(maybeThreeInARow);
      }

      function diagWinner(dir) {
        var index = dir > 0 ? -1 : 3;
        return board.map(function(row) {
          index += dir;
          return row[index]
        }).every(maybeThreeInARow);
      }

      if ([0, 1, 2].some(rowWinner) ||
          [0, 1, 2].some(columnWinner) ||
          [-1, 1].some(diagWinner))
        return winner;
    }
  }
}

TickTackToeController.prototype = {
  makeMove: function(boardSquare) {
    if (!this.model.winner && boardSquare.move == '') {
      boardSquare.move = this.model.currentPlayer;
      this.model.currentPlayer = this.model.currentPlayer == 'X' ? 'O' : 'X';
    }
  },
  reset: function() {
    this.model.currentPlayer = 'X';
    this.model.board.forEach(function(row) {
      row.forEach(function(square) {
        square.move = '';
      });
    });
  }
};

