import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class FENScreen {
    private JPanel panel;
    private JButton JButton;
    private JTextField Jlabel;
    private JButton launchBasicLayoutButton;
    private JTextField enterFenTextField;

    public FENScreen(){
        JFrame frame = new JFrame();
        frame.add(panel);
        frame.pack();
        frame.setVisible(true);
        launchBasicLayoutButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                ChessBoard chessBoard = new ChessBoard("");
                frame.setVisible(false);
            }
        });
        JButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                ChessBoard chessBoard = new ChessBoard(enterFenTextField.getText());
                frame.setVisible(false);
            }
        });
    }

}
