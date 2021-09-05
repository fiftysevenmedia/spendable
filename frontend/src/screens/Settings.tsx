import React, { useContext, useState } from 'react'
import {
  SectionList,
  Switch,
  Text,
  View,
} from 'react-native'
import { useNavigation } from '@react-navigation/native'
import { Ionicons } from '@expo/vector-icons'
import { TouchableHighlight } from 'react-native-gesture-handler'
import auth from '@react-native-firebase/auth'
import PushNotificationIOS from '@react-native-community/push-notification-ios'
import { useMutation, useQuery } from '@apollo/client'
import { TokenContext } from 'src/components/TokenContext'
import useAppStyles from 'src/utils/useAppStyles'
import { GET_NOTIFICATION_SETTINGS, UPDATE_NOTIFICATION_SETTINGS } from 'src/queries'
import { GetNotificationSettings } from 'src/graphql/GetNotificationSettings'
import { UpdateNotificationSettings } from 'src/graphql/UpdateNotificationSettings'

const Settings = () => {
  const { styles } = useAppStyles()

  const firstSection = [
    { key: 'banks', view: bankRow() },
    { key: 'templates', view: templatesRow() },
  ]

  const secondSection = [
    { key: 'notifications', view: notificationsRow() },
  ]

  const thirdSection = [
    { key: 'logout', view: logoutRow() },
  ]

  const listData = [
    { data: firstSection },
    { data: secondSection },
    { data: thirdSection },
  ]

  return (
    <SectionList
      contentContainerStyle={styles.sectionListContentContainerStyle}
      sections={listData}
      renderItem={({ item }) => item.view}
      stickySectionHeadersEnabled={false}
      renderSectionHeader={({ section }) => <View style={{ paddingBottom: 36 }} />}
    />
  )
}

const bankRow = () => {
  const { styles, fontSize, colors } = useAppStyles()
  const navigation = useNavigation<NavigationProp>()
  const navigateToBanks = () => navigation.navigate('Banks')

  return (
    <TouchableHighlight onPress={navigateToBanks}>
      <View style={styles.row}>
        <View style={{ flex: 1 }}>
          <Text style={styles.text}>
            Banks
        </Text>
        </View>

        <View style={{ flexDirection: "row" }}>
          <Ionicons name='chevron-forward-outline' size={fontSize} color={colors.secondary} />
        </View>
      </View>
    </TouchableHighlight>
  )
}

const templatesRow = () => {
  const { styles, fontSize, colors } = useAppStyles()
  const navigation = useNavigation<NavigationProp>()
  const navigateToTemplates = () => navigation.navigate('Templates')

  return (
    <TouchableHighlight onPress={navigateToTemplates}>
      <View style={styles.row}>
        <View style={{ flex: 1 }}>
          <Text style={styles.text}>
            Transaction Templates
          </Text>
        </View>

        <View style={{ flexDirection: "row" }}>
          <Ionicons name='chevron-forward-outline' size={fontSize} color={colors.secondary} />
        </View>
      </View>
    </TouchableHighlight>
  )
}

const notificationsRow = () => {
  const { styles, baseUnit } = useAppStyles()
  const [id, setId] = useState<string | null>(null)
  const [enabled, setEnabled] = useState(false)
  const { deviceToken } = useContext(TokenContext)

  PushNotificationIOS.requestPermissions()

  useQuery<GetNotificationSettings>(GET_NOTIFICATION_SETTINGS, {
    variables: { deviceToken: deviceToken },
    onCompleted: data => {
      setId(data.notificationSettings.id)
      setEnabled(data.notificationSettings.enabled)
    }
  })

  const [updateNotificationSettings] = useMutation<UpdateNotificationSettings>(UPDATE_NOTIFICATION_SETTINGS)

  const toggleSwitch = () => {
    updateNotificationSettings({ variables: { id: id, enabled: !enabled } })
    setEnabled(!enabled)
  }

  return (
    <View style={[styles.row, { padding: 0 }]}>
      <View style={{ flex: 1 }}>
        <Text style={[styles.text, { padding: baseUnit }]}>
          Notifications
        </Text>
      </View>

      <View style={{ flexDirection: "row", paddingRight: baseUnit }}>
        <Switch
          onValueChange={(toggleSwitch)}
          value={enabled}
        />
      </View>
    </View>
  )
}

const logoutRow = () => {
  const { styles } = useAppStyles()

  return (
    <TouchableHighlight onPress={() => auth().signOut()}>
      <View style={styles.row}>
        <View style={styles.flex}>
          <Text style={styles.text}>
            Logout
          </Text>
        </View>
      </View>
    </TouchableHighlight>
  )
}

export default Settings