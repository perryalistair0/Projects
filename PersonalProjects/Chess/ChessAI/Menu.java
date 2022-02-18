import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class Menu {
    private javax.swing.JPanel JPanel;
    private JButton vsPlayerButton;
    private JButton vsAIButton;
    private JButton testButton;

    public Menu() {
        make_frame();
    }

    public static void main(String[] args) {
        Menu program = new Menu();
    }
    public void make_frame(){
        JFrame frame = new JFrame();
        frame.add(JPanel);
        frame.pack();
        frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        frame.setVisible(true);

        vsPlayerButton.addActionListener(new ActionListener() {

            @Override
            public void actionPerformed(ActionEvent e) {
                frame.setVisible(false);
                FENScreen fenScreen = new FENScreen();
            }
        });
    }
}
