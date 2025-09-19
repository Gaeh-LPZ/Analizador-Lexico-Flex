package lexer.gui;

import lexer.Analizador; 
import javax.swing.*;
import javax.swing.filechooser.FileNameExtensionFilter;
import java.awt.*;
import java.io.*;

public class AnalizadorLexicoPanel extends JPanel {
    private JTextField filePathField;
    private JTextArea textArea;

    public AnalizadorLexicoPanel() {
        setLayout(new BorderLayout(10, 10));
        setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        // Panel superior
        JPanel topPanel = new JPanel(new GridBagLayout());
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5, 5, 5, 5);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        JLabel lblSelect = new JLabel("Seleccione un programa fuente:");
        filePathField = new JTextField();
        filePathField.setEditable(false);

        JButton btnOpen = new JButton("Abrir");
        JButton btnAnalyze = new JButton("Analizar");
        JButton btnClear = new JButton("Limpiar");

        btnOpen.addActionListener(e -> {
            JFileChooser chooser = new JFileChooser();
            FileNameExtensionFilter filter = new FileNameExtensionFilter("Archivos Java o Texto", "java", "txt");
            chooser.setFileFilter(filter);

            int option = chooser.showOpenDialog(this);
            if (option == JFileChooser.APPROVE_OPTION) {
                File file = chooser.getSelectedFile();
                filePathField.setText(file.getAbsolutePath());
                loadFileContent(file);
            }
        });

        // BOTÓN ANALIZAR – aquí ya usamos tu Analizador real
        btnAnalyze.addActionListener(e -> {
            String codigo = textArea.getText();
            if (codigo == null || codigo.isBlank()) {
                JOptionPane.showMessageDialog(this, "No hay código para analizar",
                        "Aviso", JOptionPane.WARNING_MESSAGE);
                return;
            }

            try {
                // Crear analizador desde el contenido del área de texto
                StringReader reader = new StringReader(codigo);
                Analizador lexer = new Analizador(reader);

                // Evitar que escriba archivos (si tu Analizador tiene limpiarArchivos, etc.)
                lexer.limpiarArchivos();

                // Procesar tokens
                lexer.yylex();

                // Aquí debes tener métodos en Analizador para recuperar las listas
                // de tokens, símbolos y errores en memoria:
                java.util.List<Object[]> listaTokens = lexer.getTokens();      // supón que devuelves List<Object[]>
                java.util.List<Object[]> listaSimbolos = lexer.getSimbolos();
                java.util.List<Object[]> listaErrores = lexer.getErrores();

                // Convertir List<Object[]> a Object[][]
                Object[][] tokens = listaTokens.toArray(new Object[0][]);
                Object[][] simbolos = listaSimbolos.toArray(new Object[0][]);
                Object[][] errores = listaErrores.toArray(new Object[0][]);

                // Mostrar en tu frame de resultados
                ResultadosLexicosFrame resultados = new ResultadosLexicosFrame(tokens, simbolos, errores);
                resultados.setVisible(true);

            } catch (Exception ex) {
                ex.printStackTrace();
                JOptionPane.showMessageDialog(this,
                        "Error durante el análisis: " + ex.getMessage(),
                        "Error", JOptionPane.ERROR_MESSAGE);
            }
        });

        btnClear.addActionListener(e -> {
            filePathField.setText("");
            textArea.setText("");
        });

        gbc.gridx = 0; gbc.gridy = 0;
        topPanel.add(lblSelect, gbc);

        gbc.gridx = 1; gbc.weightx = 1.0;
        topPanel.add(filePathField, gbc);

        gbc.gridx = 2; gbc.weightx = 0;
        topPanel.add(btnOpen, gbc);

        gbc.gridx = 1; gbc.gridy = 1;
        gbc.gridwidth = 1;
        topPanel.add(btnAnalyze, gbc);

        gbc.gridx = 2;
        topPanel.add(btnClear, gbc);

        add(topPanel, BorderLayout.NORTH);

        // Área de texto central
        textArea = new JTextArea();
        textArea.setFont(new Font(Font.MONOSPACED, Font.PLAIN, 13));
        textArea.setEditable(false);
        add(new JScrollPane(textArea), BorderLayout.CENTER);
    }

    private void loadFileContent(File file) {
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            textArea.setText("");
            String line;
            while ((line = reader.readLine()) != null) {
                textArea.append(line + "\n");
            }
        } catch (IOException ex) {
            JOptionPane.showMessageDialog(this, "Error al leer el archivo: " + ex.getMessage(),
                    "Error", JOptionPane.ERROR_MESSAGE);
        }
    }
}
