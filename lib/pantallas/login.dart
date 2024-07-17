import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'landing.dart';
import 'register.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variable para manejar la validación automática del formulario
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  // Variables para manejar la carga y errores
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Iniciar carga
        _errorMessage = ''; // Limpiar mensaje de error
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Login exitoso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login exitoso!')),
        );

        // Navegar a la pantalla principal después del login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LandingPage()),
        );

      } on FirebaseAuthException catch (e) {
        // Error en la autenticación
        String errorMessage = '';

        if (e.code == 'user-not-found') {
          errorMessage = 'Correo electrónico no encontrado.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Contraseña incorrecta.';
        } else {
          errorMessage = 'Error: ${e.message}';
        }

        setState(() {
          _errorMessage = errorMessage; // Mostrar mensaje de error
          _autovalidateMode = AutovalidateMode.always; // Habilitar validación automática
        });

      } catch (e) {
        // Otros errores
        print('Error: $e');
        setState(() {
          _errorMessage = 'Error inesperado. Por favor, inténtalo de nuevo más tarde.';
          _autovalidateMode = AutovalidateMode.always;
        });
      } finally {
        setState(() {
          _isLoading = false; // Detener carga
        });
      }
    }
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, ingrese su correo electrónico para restablecer la contraseña.';
        _autovalidateMode = AutovalidateMode.always;
      });
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Correo de restablecimiento de contraseña enviado a ${_emailController.text.trim()}')),
      );

    } on FirebaseAuthException catch (e) {
      print('Error al enviar correo de restablecimiento: ${e.message}');
      setState(() {
        _errorMessage = 'Error al enviar correo de restablecimiento: ${e.message}';
        _autovalidateMode = AutovalidateMode.always;
      });
    } catch (e) {
      print('Error inesperado: $e');
      setState(() {
        _errorMessage = 'Error inesperado. Por favor, inténtalo de nuevo más tarde.';
        _autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Cierra la aplicación cuando se presiona el botón de retroceso del teléfono
        SystemNavigator.pop();
        return true; // Retorna true para permitir salir de la aplicación
      },
      child: Scaffold(
        body: Stack(
          children: [
            OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.portrait) {
                  return _buildVerticalLayout();
                } else {
                  return _buildHorizontalLayout();
                }
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'Versión 0.1.15',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalLayout() {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode, // Habilitar la validación automática del formulario
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Iniciar Sesión en BeeZafe',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Bienvenido',
                  style: TextStyle(color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Correo electrónico',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: Icon(Icons.email),
                    errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese su correo electrónico';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: Icon(Icons.lock),
                    errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese su contraseña';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  child: _isLoading
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3,
                    ),
                  )
                      : Text('Iniciar Sesión'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade500,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => _buildResetPasswordDialog(context),
                    );
                  },
                  child: Text('Olvidé mi contraseña'),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith(
                          (states) {
                        return Colors.black;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text('No tengo cuenta'),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith(
                          (states) {
                        return Colors.black;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalLayout() {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode, // Habilitar la validación automática del formulario
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Bienvenido de nuevo',
                  style: TextStyle(color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Correo electrónico',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: Icon(Icons.email),
                    errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese su correo electrónico';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: Icon(Icons.lock),
                    errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese su contraseña';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  child: _isLoading
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3,
                    ),
                  )
                      : Text('Iniciar Sesión'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade500,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => _buildResetPasswordDialog(context),
                    );
                  },
                  child: Text('Olvidé mi contraseña'),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith(
                          (states) {
                        return Colors.black;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text('No tengo cuenta'),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith(
                          (states) {
                        return Colors.black;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetPasswordDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Restablecer Contraseña'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Ingrese su correo electrónico para recibir instrucciones de restablecimiento.'),
          SizedBox(height: 10),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'Correo electrónico',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              prefixIcon: Icon(Icons.email),
              errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingrese su correo electrónico';
              }
              return null;
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cerrar el diálogo
          },
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            _resetPassword(); // Enviar correo de restablecimiento
            Navigator.of(context).pop(); // Cerrar el diálogo
          },
          child: Text('Enviar'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.amber.shade500,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ],
    );
  }
}
