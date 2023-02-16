/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package implementaciones;

import dominio.Cliente;
import dominio.Cuenta;
import excepciones.PersistenciaException;
import interfaces.IConexionBD;
import interfaces.ICuentasDAO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author alexa
 */
public class CuentasDAO implements ICuentasDAO{

    private static final Logger LOG = Logger.getLogger(CuentasDAO.class.getName());
    private final IConexionBD generadorConexiones;

    public CuentasDAO(IConexionBD generadorConexiones) {
        this.generadorConexiones = generadorConexiones;
    }
    
    @Override
    public Cuenta insertar(Cliente cliente) throws PersistenciaException {
        Cuenta cuenta = new Cuenta();
        String sql = "insert into cuentas("
                + "estado, fechaApertura, saldo, codigoCliente)"
                + "values (?,?,?,?)";
        try (
                Connection conexion = this.generadorConexiones.crearConexion();
                PreparedStatement comando = conexion.prepareStatement(
                        sql, Statement.RETURN_GENERATED_KEYS);) {
            comando.setString(1, cuenta.getEstado());
            comando.setDate(2, (java.sql.Date) cuenta.getFechaApertura());
            comando.setFloat(3, cuenta.getSaldo());
            comando.setInt(4, cliente.getCodigo());
            comando.executeUpdate();
            // ResultSet: objeto que devuelve la base al consultar
            ResultSet llavesGeneradas = comando.getGeneratedKeys();
            if (llavesGeneradas.next()) {
                Integer llavePrimaria = llavesGeneradas.getInt(1);
                cuenta.setCodigo(llavePrimaria);
                return cuenta;
            }
            LOG.log(Level.WARNING, "Cliente registrado, pero código no generado");
            throw new PersistenciaException("Cliente registrado, pero código no generado");
        } catch (SQLException ex) {
            LOG.log(Level.SEVERE, ex.getMessage());
            throw new PersistenciaException("No fue posible registrar al cliente");
        } 
    }

    @Override
    public Cuenta consultar(Integer codigoCuenta) {
        String sql = "select codigo, estado, fechaApertura, saldo, codigoCliente"
                + "from cuentas where codigo = ?";
        try (
                Connection conexion = this.generadorConexiones.crearConexion();
                PreparedStatement comando = conexion.prepareStatement(sql);) {
            comando.setInt(1, codigoCuenta);
            ResultSet registro = comando.executeQuery();
            // SI SE ENCONTRÓ A LA CUENTA
            Cuenta cuenta = null;
            if (registro.next()) {
                Integer codigo = registro.getInt("codigo");
                String estado = registro.getString("estado");
                Date fechaApertura = registro.getDate("fechaApertura");
                float saldo = registro.getFloat("saldo");
                Integer codigoCliente = registro.getInt("codigoCliente");
                cuenta = new Cuenta(codigo, estado, fechaApertura, saldo,
                        codigoCliente);
            }
            return cuenta;
        } catch (SQLException ex) {
            LOG.log(Level.SEVERE, ex.getMessage());
            return null;
        }
    }

}
